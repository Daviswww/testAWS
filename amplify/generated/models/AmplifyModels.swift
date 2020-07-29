// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "d50902573697862d52af6205391dd1ac"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Task.self)
    ModelRegistry.register(modelType: Note.self)
    ModelRegistry.register(modelType: Todo.self)
  }
}