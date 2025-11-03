class Ionian < Formula
  desc "A fast and simple static site generator."
  homepage "https://puma.farthergate.com"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.1/ionian-aarch64-apple-darwin.tar.xz"
      sha256 "46d10f6af9f9e683aa6c338cac38e93aee3ea90257d576fb0c3a5d84a4ad5f68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.1/ionian-x86_64-apple-darwin.tar.xz"
      sha256 "b159462709a751491707823ba4b94d5c2782a6a03a2cadf323150549fb580bf7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.1/ionian-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e57c49a27ad0daa4d5b71e45611a6897490dd72b90451d8d67e9d65babd3ea90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.2.1/ionian-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "250b1b13c6efe0695aa6428ab2b0f9bf276edf80b572be3f17b8d8532c3ec2c4"
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
