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
  version "0.3.9"
  license "Apache-2.0"

  # Each platform gets a self-contained executable compiled by `bun build
  # --compile`, so there is nothing to build here and no bottle to pour. The
  # release assets live on the public CLI mirror.
  on_macos do
    on_arm do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-darwin-arm64"
      sha256 "1186cfe38beac686d52ac87eb94ac2b80fe3dfe876dbb472f7f7664346bbbbb9"
    end

    on_intel do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-darwin-x64"
      sha256 "d1a19d1a616909f96e03da9e713ab6207419c788bfdd0992cbea7f1296aaba3f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-linux-arm64"
      sha256 "81c7b4d2f545b6f9ac8ed63889dbeddb86692c6aa4808302231f8579ba2fd932"
    end

    on_intel do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-linux-x64"
      sha256 "1d8516864574a95216cd270cd8df3527a1cfca15575a7e5147dfaa18a81404d4"
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
