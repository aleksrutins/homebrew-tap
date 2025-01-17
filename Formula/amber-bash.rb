class AmberBash < Formula
  desc "Amber, the programming language that compiles to Bash"
  homepage "https://amber-lang.com"
  url "https://github.com/Ph0enixKM/Amber/releases/download/0.3.4-alpha/source.tar.gz"
  sha256 "26da447d26b1c502b87055fdaae3a62f443e4f0d1c8866e6dca995ee664cc3b4"
  license "GPL-3.0-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      Programs written in amber require Bash to run. macOS and most Linux distributions ship with bash preinstalled, but some (Alpine, for instance) do not.

      In order to run built programs, please make sure you have Bash already installed.
    EOS
  end

  test do
    (testpath/"main.ab").write('
	let name = "World"
	echo "Hello, {name}"
    ')

    assert_equal "Hello, World", shell_output("#{bin}/amber main.ab").strip
  end

  def cleanup
    # Prevent the caveats message from being printed again
    odisabled "caveats"
  end
end
