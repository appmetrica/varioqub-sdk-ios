// this is a part of Public/NetworkLogger.swift
// jazzy process all variables and ignore #if. So now it's spliited by two files
// When varioqub will be ready for opensource VarioqubLogger must be removed and replaced by swift-log
// TODO: merge with NetworkLogger.swift

#if !VQ_LOGGER
import Logging
public let networkLoggerString = "com.varioqub.network"
let networkLogger = Logger(label: networkLoggerString)
#endif
