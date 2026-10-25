class Ionian < Formula
  desc "A fast and simple static site generator."
  homepage "https://ionian.farthergate.com"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.3.2/ionian-aarch64-apple-darwin.tar.xz"
      sha256 "440c72fc0e8e66c5209eb1a213c9743c72107e989be0347fba8637e2201a2b99"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.3.2/ionian-x86_64-apple-darwin.tar.xz"
      sha256 "813cb141862990413de1d52b656814d9d4e64aa017b486f7ec25aec02d3f48b6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.3.2/ionian-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ae972ff5a8cfd2bf3f80d9685b9d2ccd9dba18dda1de775ef43b007df3d8cae8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.3.2/ionian-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bccf98c986cea642148eaa8d2e39bd071255ca4caaead6cc343ab0a460298300"
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
