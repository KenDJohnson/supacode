import Foundation

nonisolated enum SupacodePaths {
  static var baseDirectory: URL {
    FileManager.default.homeDirectoryForCurrentUser
      .appending(path: ".supacode", directoryHint: .isDirectory)
  }

  static var reposDirectory: URL {
    baseDirectory.appending(path: "repos", directoryHint: .isDirectory)
  }

  static func repositoryDirectory(for rootURL: URL, configuredName: String?) -> URL {
    let resolvedRootURL = rootURL.standardizedFileURL
    let fallback = resolvedRootURL.path(percentEncoded: false).replacing("/", with: "_")
    let candidate = Repository.directoryName(
      for: resolvedRootURL,
      configuredName: configuredName
    )
    let name = Repository.isValidDirectoryName(candidate) ? candidate : fallback
    return reposDirectory.appending(path: name, directoryHint: .isDirectory)
  }

  static func worktreeBaseDirectory(
    for rootURL: URL,
    configuredName: String?,
    configuredWorktreeDirectory: String?
  ) -> URL {
    if let configuredPath = normalizedWorktreeDirectory(configuredWorktreeDirectory) {
      return URL(filePath: configuredPath, directoryHint: .isDirectory)
    }
    return repositoryDirectory(for: rootURL, configuredName: configuredName)
  }

  static func normalizedWorktreeDirectory(_ configuredWorktreeDirectory: String?) -> String? {
    guard let configuredWorktreeDirectory else {
      return nil
    }
    let trimmed = configuredWorktreeDirectory.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      return nil
    }
    guard trimmed.hasPrefix("/") else {
      return nil
    }
    guard
      !trimmed.unicodeScalars.contains(where: { CharacterSet.controlCharacters.contains($0) })
    else {
      return nil
    }
    let url = URL(filePath: trimmed, directoryHint: .isDirectory).standardizedFileURL
    return url.path(percentEncoded: false)
  }

  static var settingsURL: URL {
    baseDirectory.appending(path: "settings.json", directoryHint: .notDirectory)
  }
}
