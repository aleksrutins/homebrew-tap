class Ionian < Formula
  desc "A fast and simple static site generator."
  homepage "https://ionian.farthergate.com"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.1/ionian-aarch64-apple-darwin.tar.xz"
      sha256 "fb6b989c8f08c6437d44c496174d03462f38ea055b823a45e1d9fbf65746b337"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.1/ionian-x86_64-apple-darwin.tar.xz"
      sha256 "6a99b1bdd3ac49bef7173c76269a272b366ec056dc8ebd697a70cd9f93d321db"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.1/ionian-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc2e0cd1a65e0de02afe5f9901b1a0aaeb40f952558e7ffe87d753cc5f525139"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.4.1/ionian-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8f6c2229ca8c9ffe335ed7879e90f7bfe425234f3ee3d7fb577dfdd6f347e2ea"
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
