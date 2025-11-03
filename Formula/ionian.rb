class Ionian < Formula
  desc "A fast and simple static site generator."
  homepage "https://puma.farthergate.com"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.0/ionian-aarch64-apple-darwin.tar.xz"
      sha256 "225e9c95b50e813e4babd95559784bb32bf1c54e5e3fac6b43fe04fedb9fe32b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.0/ionian-x86_64-apple-darwin.tar.xz"
      sha256 "29fde0c189f63327697d947780ea05a110481f291a04102ef5d620c92ed97b43"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.0/ionian-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "17eabc8e4f4d29d3706c2f364014cf1f2e05afc7402ecb6a794d13ba58cd03ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.0/ionian-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e11e3d8abf58badfebcd521ae5856ce7873e552e44800a363e4e91f5ddb49f1"
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
