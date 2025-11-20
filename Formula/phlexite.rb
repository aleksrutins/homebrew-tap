# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://docs.brew.sh/rubydoc/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Phlexite < Formula
  desc ""
  homepage ""
  url "https://git.sr.ht/~aleksrutins/phlexite-cli",
    tag: "v0.1.0"
  sha256 "7926883e9e0513a4750837bd1efec1dddcf0f803d507a458d2b84f5ef7559463"
  license ""

  uses_from_macos "ruby"

  # Additional dependency
  # resource "" do
  #   url ""
  #   sha256 ""
  # end

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "bundle", "exec", "rake", "install"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test phlexite`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "true"
  end
end
