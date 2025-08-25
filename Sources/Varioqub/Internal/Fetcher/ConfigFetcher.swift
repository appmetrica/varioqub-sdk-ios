import Foundation
#if VQ_MODULES
import VarioqubNetwork
import VarioqubUtils
#endif
import SwiftProtobuf

private enum RequestParams {
    static let clientId = "client_id"
}

final class ConfigFetcher {

    let networkClient: NetworkRequestCreator
    let idProvider: VarioqubIdProvider
    let config: InternalConfig
    let settings: ConfigFetcherSettings
    let identifiersProvider: VarioqubIdentifiersProvider
    let executor: AsyncExecutor
    let output: ConfigFetcherOutput
    let environmentProvider: EnvironmentProvider
    let runtimeOptions: VarioqubRuntimeOptionable
    let threadChecker: ThreadChecker

    init(networkClient: NetworkRequestCreator, idProvider: VarioqubIdProvider, config: InternalConfig,
         settings: ConfigFetcherSettings, identifiersProvider: VarioqubIdentifiersProvider, executor: AsyncExecutor,
         output: ConfigFetcherOutput, environmentProvider: EnvironmentProvider,
         runtimeOptions: VarioqubRuntimeOptionable, threadChecker: ThreadChecker) {
        self.networkClient = networkClient
        self.config = config
        self.idProvider = idProvider
        self.settings = settings
        self.executor = executor
        self.identifiersProvider = identifiersProvider
        self.output = output
        self.environmentProvider = environmentProvider
        self.runtimeOptions = runtimeOptions
        self.threadChecker = threadChecker
    }

    private var locker = UnfairLock()
    private var inProgress = false

    private var callbacks: [ConfigFetchCallback] = []

}

extension ConfigFetcher: ConfigFetchable {

    func fetchExperiments(callback: ConfigFetchCallback?) {
        varioqubLogger.trace("fetchExperiments")
        threadChecker.check()

        var needStartRequest = false

        let lastFetchDate = settings.lastFetchDate
        let currentDate = environmentProvider.currentDate

        if lastFetchDate.addingTimeInterval(config.fetchThrottle) > currentDate {
            varioqubLogger.trace("fetchExperiments throttled: lastFetch=\(lastFetchDate) current=\(currentDate)")
            if let callback = callback {
                executor.execute { [threadChecker] in
                    threadChecker.check()
                    callback(.throttled)
                }
            }
            return
        }

        locker.lock {
            if !inProgress {
                needStartRequest = true
            }
            inProgress = true

            if let callback = callback {
                callbacks.append(callback)
            }
        }

        varioqubLogger.trace(needStartRequest ? "prepare to start request" : "wait for current request completed")

        if needStartRequest {
            doFetchExperiments { [threadChecker] error in
                threadChecker.check()

                var callbacks: [ConfigFetchCallback] = []
                self.locker.lock {
                    self.inProgress = false
                    callbacks = self.callbacks
                    self.callbacks = []
                }

                callbacks.forEach { $0(error) }
            }
        }

    }

}

private extension ConfigFetcher {

    func doFetchExperiments(_ callback: @escaping ConfigFetchCallback) {
        idProvider.fetchIdentifiers { result in
            self.executor.execute {
                switch result {
                case .success(let id):
                    self.doFetchExperiments(userId: id.userId, deviceId: id.deviceId, callback)
                case .failure:
                    callback(.error(.nullIdentifiers))
                }
            }
        }
    }

    func doFetchExperiments(userId: String, deviceId: String, _ callback: @escaping ConfigFetchCallback) {
        threadChecker.check()

        let id = identifiersProvider.varioqubIdentifier
        let dataRequest = createRequest(id: id, userId: userId, deviceId: deviceId)
        let etag = settings.etag


        do {
            varioqubLogger.trace("request: \(dataRequest)")

            let data: Data = try dataRequest.serializedData()
            let request = Request.post(path: "v1/app", body: data, params: [RequestParams.clientId: config.clientId])
                    .withContentType("application/x-protobuf")
                    .withIfNoneMatch(etag)

            varioqubLogger.trace("request etag: \(etag ?? "")")
            varioqubLogger.trace("request data: \(data.base64EncodedString())")

            networkClient.makeRequest(request, baseURL: config.baseURL)
                    .onCallback { [weak self] response in self?.handleNetworkResponse(response, callback: callback) }
                    .execute()

        } catch let e as ConfigFetcherError {
            callback(.error(e))
        } catch _ as BinaryEncodingError {
            callback(.error(.request))
        } catch let e {
            callback(.error(.underlying(e)))
        }
    }

    func handleNetworkResponse(_ response: NetworkResponse, callback: @escaping ConfigFetchCallback) {
        threadChecker.check()

        let result: VarioqubFetchAnswer
        defer { callback(result) }

        switch response {
        case .validAnswer(let ans):
            varioqubLogger.debug("response status: \(ans.statusCode)")
                            varioqubLogger.trace("response data: \(ans.body?.base64EncodedString() ?? "")")
            if let body = ans.body, !body.isEmpty {
                let etag = ans.headers.etag
                settings.etag = etag
                
                do {
                    let model = NetworkDataModel(version: .current, data: body, fetchDate: environmentProvider.currentDate)
                    try output.updateNetworkData(model)
                    
                    settings.lastFetchDate = environmentProvider.currentDate
                    result = .success
                } catch let e {
                    result = .error(.parse(e))
                }
            } else if ans.statusCode == .notModified {
                // no need to do something. Data wasn't changed
                settings.lastFetchDate = environmentProvider.currentDate
                result = .cached
            } else {
                result = .error(.emptyResult)
            }
        case .serverError(let err):
            varioqubLogger.debug("server error: \(err)")
            result = .error(.response(ConfigFetcherResponseError.serverError))
        case .networkError(let e):
            result = .error(.network(e))
        }
    }

    func createRequest(id: String?, userId: String, deviceId: String) -> PBRequest {
        let dataRequest = PBRequest.with {

            $0.userID = userId
            $0.deviceID = deviceId
            if let id = id {
                $0.id = id
            }

            $0.platform = environmentProvider.platform
            $0.language = environmentProvider.language
            $0.version = environmentProvider.version
            $0.versionCode = environmentProvider.versionCode
            $0.sdkVersion = varioqubVersion.description
            $0.osVersion = environmentProvider.osVersion
            $0.osHumanVersion = environmentProvider.osVersion
            $0.sdkAdapterName = config.repoterName
            $0.sdkIDAdapterName = config.idProviderName

            $0.clientFeatures = runtimeOptions.clientFeatures.features.map { (ck, cv) in
                PBClientFeature.with {
                    $0.name = ck
                    $0.value = cv
                }
            }
        }

        return dataRequest
    }

}
