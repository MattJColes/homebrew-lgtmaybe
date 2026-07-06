class Lgtmaybe < Formula
  include Language::Python::Virtualenv

  desc "Provider-agnostic pull request reviewer with keyless cloud auth"
  homepage "https://mattjcoles.github.io/lgtmaybe/"
  url "https://files.pythonhosted.org/packages/76/36/e9332fa94768b531f883ee8278d17c074b7e1b321c9c14d83f9b84757b59/lgtmaybe-0.11.0.tar.gz"
  sha256 "36446d4ffb1be1a2cc3af429585d7392ff8f27089e08c3fa007935dcfb34848a"
  license "MIT"

  # The dependency wheels ship prebuilt extension dylibs (e.g. jiter) whose
  # install names use @rpath and lack header padding, so Homebrew cannot rewrite
  # them to an absolute path ("Failed to fix install linkage"). Preserve the
  # @rpath ids — they resolve correctly from the venv's fixed location anyway.
  preserve_rpath

  depends_on "ast-grep"
  depends_on "python@3.12"

  def install
    # lgtmaybe's dependency tree includes Rust extensions (tokenizers, hf-xet)
    # whose sdists cannot build inside Homebrew's sandbox, so install lgtmaybe and
    # its dependencies from upstream PyPI wheels into an isolated virtualenv. The
    # venv is created plainly so ensurepip provides pip.
    system "python3.12", "-m", "venv", libexec
    system libexec/"bin/python", "-m", "pip", "install", "lgtmaybe==#{version}"
    bin.install_symlink libexec/"bin/lgtmaybe"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/lgtmaybe --help")
  end
end
