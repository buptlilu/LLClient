//
//  Cache.swift
//  LLCommon
//
//  Created by lilu on 2022/4/2.
//

import Foundation

public class Cache: NSObject {
    public func save<ModelType: Codable>(filePath: URL?, models: ModelType, completeBlock: ((Bool)->Void)? = nil) {
        DispatchQueue.global().async {
            if let path = filePath  {
                do {
                    let datasToWrite = try JSONEncoder().encode(models)
                    try datasToWrite.write(to: path)
                    Logger.info("success to save models:\(models)")
                    completeBlock?(false)
                } catch {
                    completeBlock?(false)
                    Logger.error("fail to save error:\(error)")
                }
            } else {
                Logger.error("fail to save because path is invalid:\(filePath)")
                completeBlock?(false)
            }
        }
    }
    
    public func loadSync<ModelType: Codable>(filePath: URL?,modelType: ModelType.Type, completeBlock: ((Bool, ModelType?)->Void)? = nil) {
        loadInternal(filePath: filePath, modelType: modelType, completeBlock: completeBlock)
    }
    
    
    public func load<ModelType: Codable>(filePath: URL?,modelType: ModelType.Type, completeBlock: ((Bool, ModelType?)->Void)? = nil) {
        DispatchQueue.global().async {
            self.loadInternal(filePath: filePath, modelType: modelType, completeBlock: completeBlock)
        }
    }
    
    private func loadInternal<ModelType: Codable>(filePath: URL?,modelType: ModelType.Type, completeBlock: ((Bool, ModelType?)->Void)? = nil) {
        if let path = filePath  {
            do {
                if FileManager.default.fileExists(atPath: path.path) {
                    let datas = try Data.init(contentsOf: path)
                    let models = try JSONDecoder().decode(ModelType.self, from: datas)
                    Logger.info("success to load models:\(models)")
                    completeBlock?(true, models)
                } else {
                    Logger.info("fail to load because path not exist:\(path.path)")
                    completeBlock?(false, nil)
                }
            } catch {
                Logger.error("fail to load because path is invalid:\(filePath)")
                completeBlock?(false, nil)
            }
        }
    }
    
    public static var shared = Cache()
}
