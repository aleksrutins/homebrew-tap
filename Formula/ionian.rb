class Ionian < Formula
  desc "A fast and simple static site generator."
  homepage "https://puma.farthergate.com"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.1.2/ionian-aarch64-apple-darwin.tar.xz"
      sha256 "000982eaae078ce4dcf5666820bb6485471b5ac49c80d3bcffcac5c07261a0a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.1.2/ionian-x86_64-apple-darwin.tar.xz"
      sha256 "b688a72a98286b700a578841e2917fee7a83fbd0358de54f86c33c2f80c8c8f7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.1.2/ionian-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6f5be28bbacf6e8580888011367d20bfc80e362fe8b7d566e0f54305e1939df9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.1.2/ionian-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "003b760ed91e0d053200f8fc2c7589b62d12edb1121e7a02261062c34a6723e6"
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
