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
  version "0.7.2"
  license "Apache-2.0"

  # Each platform gets a self-contained executable compiled by `bun build
  # --compile`, so there is nothing to build here and no bottle to pour. The
  # release assets live on the public CLI mirror.
  on_macos do
    on_arm do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-darwin-arm64"
      sha256 "c8a50aae2441c1d246623eb2bb93d14f26508b519c30e84bfd7b3689dd48e0b1"
    end

    on_intel do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-darwin-x64"
      sha256 "d216625053472a42968e018fcae146182d2205f6f9f6f08603f2b49fe6f1b28b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-linux-arm64"
      sha256 "a8d1fdeec16d37df896df64202eef98e5bc16ef888a595948ab956c9c565b1f4"
    end

    on_intel do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-linux-x64"
      sha256 "712c97876343120da3f2c00d616d652d2cffb0fb9996db41f21be62755e39411"
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
