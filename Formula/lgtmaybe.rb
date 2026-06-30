class Lgtmaybe < Formula
  include Language::Python::Virtualenv

  desc "Provider-agnostic pull request reviewer with keyless cloud auth"
  homepage "https://mattjcoles.github.io/lgtmaybe/"
  url "https://files.pythonhosted.org/packages/e7/3b/947e3e914dbdd224289f08c696a5c38a6c4a4e493bce357aa1edf2199f62/lgtmaybe-0.7.0.tar.gz"
  sha256 "88f6f8f41b30dcf23adfe7dcc7e2568828d0d0ae9362ce65753760307c4975e9"
  license "MIT"

  depends_on "ast-grep"
  depends_on "python@3.12"

  def install
    # lgtmaybe's dependency tree includes Rust extensions (tokenizers, hf-xet)
    # whose sdists cannot build inside Homebrew's sandbox, so install lgtmaybe and
    # its dependencies from upstream PyPI wheels into an isolated virtualenv. The
    # venv is created plainly (so ensurepip provides pip); the CI bottle build
    # disables the sandbox so this pip can reach PyPI, and end users pour the
    # resulting bottle instead of running this.
    system "python3.12", "-m", "venv", libexec
    system libexec/"bin/python", "-m", "pip", "install", "--verbose", "lgtmaybe==#{version}"
    bin.install_symlink libexec/"bin/lgtmaybe"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/lgtmaybe --help")
  end
end
