# sferarc/homebrew-pgbeam

The Homebrew tap for [PgBeam](https://pgbeam.com).

```bash
brew install sferarc/pgbeam/pgbeam
```

That is the short form of adding the tap and then installing from it:

```bash
brew tap sferarc/pgbeam
brew install pgbeam
```

Upgrading is `brew upgrade pgbeam` like any other formula. (`pgbeam update`, the CLI's own self-update, replaces the binary underneath Homebrew's bookkeeping, so on a Homebrew install prefer `brew upgrade`.)

## What is in here

One formula, `Formula/pgbeam.rb`, which installs the PgBeam CLI: a self-contained native binary for macOS and Linux, on both arm64 and x86_64. It pulls the prebuilt release asset for the platform from [sferarc/pgbeam-cli](https://github.com/sferarc/pgbeam-cli/releases) and checks it against a pinned sha256.

The CLI source, and everything about what the CLI does, lives in [sferarc/pgbeam-cli](https://github.com/sferarc/pgbeam-cli). It is also on npm as [`@pgbeam/cli`](https://www.npmjs.com/package/@pgbeam/cli), which is the better choice if you would rather have it as a project dependency than a global binary.

## Automation

The formula's version and checksums are written by PgBeam's release pipeline on every CLI release, so a stale pin here is a bug rather than something waiting on a maintainer. This repository is a mirror: it is generated from a directory in the PgBeam monorepo and pushed here automatically, so a change made directly on it is synced back for review rather than merged in place.

## License

Apache-2.0
