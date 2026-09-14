# The PgBeam CLI.
#
# `version` and every `sha256` below are written by the release pipeline, not by
# hand: .github/workflows/release.yml (job `cli-homebrew`) reads the checksums off
# the binaries it has just built and published, rewrites this file through
# .github/scripts/commit-homebrew-formula.sh, and the mirror sync pushes it to
# sferarc/homebrew-pgbeam. An edit made here by hand is overwritten by the next
# release, and a checksum that does not match the release asset breaks
# `brew install` for everyone.
#
# The all-zero checksums are placeholders, and they are deliberately impossible
# rather than merely wrong: `brew install` refuses to install against them, which
# is what should happen before any release has run. Nothing about them looks like
# a real digest, so nobody can mistake one for a value that was checked.
class Pgbeam < Formula
  desc "PgBeam CLI: safe PostgreSQL access for AI agents, from the terminal"
  homepage "https://pgbeam.com"
  version "0.3.10"
  license "Apache-2.0"

  # Each platform gets a self-contained executable compiled by `bun build
  # --compile`, so there is nothing to build here and no bottle to pour. The
  # release assets live on the public CLI mirror.
  on_macos do
    on_arm do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-darwin-arm64"
      sha256 "547218c11cee5fccb5121d1f0a9aaf8a3f23b11b2d742c63045183dab2129fc2"
    end

    on_intel do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-darwin-x64"
      sha256 "44a0720b70b1b330b43a9324205384cd3254e584f4c13610b90cd8d0ae924ef1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-linux-arm64"
      sha256 "b65831e5e2eeafde8e5ab491afdd1b4437816deb5de8533cbbc34a3eaeda5d03"
    end

    on_intel do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-linux-x64"
      sha256 "137f7dde513360272c08df6dd4364856770ab11fdf2faf866062e3a623eb5e3e"
    end
  end

  livecheck do
    url :url
    strategy :github_latest
  end

  def install
    # The asset is a bare executable named for its platform, not an archive, so
    # Homebrew leaves it alone and it arrives in the staging directory under that
    # name. Rename it on the way into bin/.
    binary = Dir["pgbeam-*"].first
    odie "no pgbeam binary in the downloaded release asset" if binary.nil?

    bin.install binary => "pgbeam"

    # No shell completions. The CLI is built on citty, which ships no completion
    # generator, and `pgbeam` has no `completion` subcommand to shell out to, so
    # there is nothing here to install. If one is added,
    # `generate_completions_from_executable` belongs at this point.
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgbeam --version")
    assert_match "PgBeam CLI", shell_output("#{bin}/pgbeam --help")
  end
end
