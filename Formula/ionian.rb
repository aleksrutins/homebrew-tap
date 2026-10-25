class Ionian < Formula
  desc "A fast and simple static site generator."
  homepage "https://ionian.farthergate.com"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.3.3/ionian-aarch64-apple-darwin.tar.xz"
      sha256 "5a493f62c06aa2f1e411ac6adf790f215854766fac3a49ce5919966ba183d662"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.3.3/ionian-x86_64-apple-darwin.tar.xz"
      sha256 "6e8b52d566c249d4d66e145f624d77237a4445fdc4f25d1c1d3208baed75e329"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.3.3/ionian-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5786491efc876cc9dc884716a5d32e3da483b0b4fbc064a648e8f02f84f80c41"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aleksrutins/ionian/releases/download/v0.3.3/ionian-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e614402b9592de92b08585fa9e13f9e59f3589bb9060fc0887d7505914580628"
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
