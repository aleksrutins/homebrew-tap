class Ionian < Formula
  desc "A fast and simple static site generator."
  homepage "https://ionian.farthergate.com"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.0/ionian-aarch64-apple-darwin.tar.xz"
      sha256 "c49a83b00ee54bd5baa03fb061287eed87bd9370fad877d5ad5e06010735b0e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.0/ionian-x86_64-apple-darwin.tar.xz"
      sha256 "888593b1c6196b2dc289b48251b492f3be84293e7c4df9214c1f4a27dd009e89"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.0/ionian-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "24af21965fe8c1073f9f1a586abe68a12a743062dd7c67f62e35fd9562daffa7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.0/ionian-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0d0609c77b062f6322b300560b6ec360264cc34e5937bc38d9e75a522ed47f6a"
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
