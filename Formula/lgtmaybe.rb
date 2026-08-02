class Lgtmaybe < Formula
  include Language::Python::Virtualenv

  desc "Provider-agnostic pull request reviewer with keyless cloud auth"
  homepage "https://lgtmaybe.coles.codes/"
  url "https://files.pythonhosted.org/packages/09/c7/53a976e14a4e491bd4d094768091460fb71be94a2e10a1f35b3144de04a9/lgtmaybe-1.11.1.tar.gz"
  sha256 "15a985afabb1ad3d1d3ecac341fbe1c56ed658454de5af04e6b82db150e7629d"
  license "MIT"

  # The dependency wheels ship prebuilt extension dylibs (e.g. jiter) whose
  # install names use @rpath and lack header padding, so Homebrew cannot rewrite
  # them to an absolute path ("Failed to fix install linkage"). Preserve the
  # @rpath ids — they resolve correctly from the venv's fixed location anyway.
  preserve_rpath

  depends_on "ast-grep"
  depends_on "python@3.12"

  def install
    # lgtmaybe's dependency tree includes Rust extensions (tokenizers, hf-xet,
    # and litellm >= 1.92, which ships only manylinux wheels) whose sdists
    # cannot build inside Homebrew's sandbox (no Cargo), so install lgtmaybe
    # and its dependencies from upstream PyPI wheels into an isolated
    # virtualenv. --prefer-binary makes pip back off to the newest version
    # that has a macOS-compatible wheel instead of grabbing a newer sdist it
    # would then fail to compile. The venv is created plainly so ensurepip
    # provides pip.
    system "python3.12", "-m", "venv", libexec
    system libexec/"bin/python", "-m", "pip", "install", "--prefer-binary",
           "lgtmaybe==#{version}"
    bin.install_symlink libexec/"bin/lgtmaybe"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/lgtmaybe --help")
  end
end
