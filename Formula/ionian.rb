class Ionian < Formula
  desc "A fast and simple static site generator."
  homepage "https://ionian.farthergate.com"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.2/ionian-aarch64-apple-darwin.tar.xz"
      sha256 "f85de11e9bba04705429516372e304b053db24c8a48e8a4ca3d4841ffbff35cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.2/ionian-x86_64-apple-darwin.tar.xz"
      sha256 "d8ae85d4bd4781e737cc935e0bfbd9696865668002c2a71135a61a4de8f107de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.2/ionian-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "23e447b49b69cdf43e42c0b3966b3da2435bb2d840e413c974bd1484161558ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.2/ionian-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f6e46e8157a9e6ceabc5ba6c616bd868297ce1a2f08160e8e86068b1ef4fa2f5"
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
