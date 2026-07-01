class Lgtmaybe < Formula
  include Language::Python::Virtualenv

  desc "Provider-agnostic pull request reviewer with keyless cloud auth"
  homepage "https://mattjcoles.github.io/lgtmaybe/"
  url "https://files.pythonhosted.org/packages/a1/f4/ed1a04079f72008b8563f2d140fa3ad19bff56ae80267453776614bf8852/lgtmaybe-0.9.1.tar.gz"
  sha256 "794f545ff2e61ce09939505f0e82b1e26aef1e6ef7013e18a9489260629ce5aa"
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
