class Lgtmaybe < Formula
  include Language::Python::Virtualenv

  desc "Provider-agnostic pull request reviewer with keyless cloud auth"
  homepage "https://mattjcoles.github.io/lgtmaybe/"
  url "https://files.pythonhosted.org/packages/8c/61/54d020bb287ce6c8fbf2c49f234846bf74c2383e6270cdb81b0b0af8e100/lgtmaybe-0.10.0.tar.gz"
  sha256 "f92ec770648b98c25117c370e401a208d1a2148f61f857af7e21480e645a310b"
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
