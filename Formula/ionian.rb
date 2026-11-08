class Ionian < Formula
  desc "A fast and simple static site generator."
  homepage "https://ionian.farthergate.com"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.2/ionian-aarch64-apple-darwin.tar.xz"
      sha256 "3127253b874d959f298d982d44559d6214686a4e5508d0a1c1dc293dfd358c52"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.2/ionian-x86_64-apple-darwin.tar.xz"
      sha256 "575cbe4c2bf76e0f732d67547c6c84395c654232b8678e114e9b8150909a8604"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.2/ionian-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ff1f3b0fb27d4468af7ff7ceea05df6b4201e042ddedaffdcf0f028c5c85194a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.2/ionian-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b260ca3922c7824c8c95d9f094083bd24a3543790b9e260e7c333026368e1f86"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ionian"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ionian"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ionian"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ionian"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
