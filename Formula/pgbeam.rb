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
  version "0.6.0"
  license "Apache-2.0"

  # Each platform gets a self-contained executable compiled by `bun build
  # --compile`, so there is nothing to build here and no bottle to pour. The
  # release assets live on the public CLI mirror.
  on_macos do
    on_arm do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-darwin-arm64"
      sha256 "5d608b71debcb4cfaad4dc3602ebec6660ce6f9591a03b954e8f0a2ae0227e21"
    end

    on_intel do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-darwin-x64"
      sha256 "0bd050405ec87bbbcbd0c95cd33cdf49305f50719c1a01722c52723da8ebeec0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-linux-arm64"
      sha256 "22cb5183e8425befdf0d8db0ee103139258a038ce2ce54ac6b082ad4ae4880b4"
    end

    on_intel do
      url "https://github.com/sferarc/pgbeam-cli/releases/download/v#{version}/pgbeam-linux-x64"
      sha256 "277bfcf4de2ac92091a77e642bb04c30be3e49472407a346e23ece0b25ab2067"
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
