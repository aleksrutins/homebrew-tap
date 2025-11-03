class Ionian < Formula
  desc "A fast and simple static site generator."
  homepage "https://puma.farthergate.com"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.1.0/ionian-aarch64-apple-darwin.tar.xz"
      sha256 "b6aab325b973cb6d8f0caf3e944ef6d3d3578957271db6c7744bb2409e577527"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.1.0/ionian-x86_64-apple-darwin.tar.xz"
      sha256 "811626db2427ec45223d7232ed015728460e3977b9e7be0ddd53d672d6d470d9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.1.0/ionian-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e1a203d7b18f483a8f6bad6eac466b182bb28940d5052700ac8eaa2f37cc603e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.1.0/ionian-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9b253e1188ffa438c299592182a0d4226187052ba75d371980168ee1a5ce248"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ionian" if OS.mac? && Hardware::CPU.arm?
    bin.install "ionian" if OS.mac? && Hardware::CPU.intel?
    bin.install "ionian" if OS.linux? && Hardware::CPU.arm?
    bin.install "ionian" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
