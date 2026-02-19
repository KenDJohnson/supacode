import Foundation
import Testing

@testable import supacode

struct SupacodePathsTests {
  @Test func worktreeBaseDirectoryUsesConfiguredAbsolutePath() {
    let rootURL = URL(fileURLWithPath: "/tmp/repo-a")
    let configuredDirectory = FileManager.default.temporaryDirectory
      .appending(path: "worktrees-\(UUID().uuidString)", directoryHint: .isDirectory)
      .standardizedFileURL
    let baseDirectory = SupacodePaths.worktreeBaseDirectory(
      for: rootURL,
      configuredName: "workspace-repo",
      configuredWorktreeDirectory: configuredDirectory.path(percentEncoded: false)
    )

    #expect(baseDirectory.standardizedFileURL == configuredDirectory)
  }

  @Test func worktreeBaseDirectoryFallsBackWhenConfiguredPathIsRelative() {
    let rootURL = URL(fileURLWithPath: "/tmp/repo-a")
    let baseDirectory = SupacodePaths.worktreeBaseDirectory(
      for: rootURL,
      configuredName: "workspace-repo",
      configuredWorktreeDirectory: "relative/worktrees"
    )
    let expected = SupacodePaths.repositoryDirectory(
      for: rootURL,
      configuredName: "workspace-repo"
    )

    #expect(baseDirectory == expected)
  }

  @Test func worktreeBaseDirectoryFallsBackWhenConfiguredPathIsEmpty() {
    let rootURL = URL(fileURLWithPath: "/tmp/repo-a")
    let baseDirectory = SupacodePaths.worktreeBaseDirectory(
      for: rootURL,
      configuredName: "workspace-repo",
      configuredWorktreeDirectory: "   "
    )
    let expected = SupacodePaths.repositoryDirectory(
      for: rootURL,
      configuredName: "workspace-repo"
    )

    #expect(baseDirectory == expected)
  }
}
