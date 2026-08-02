class Lgtmaybe < Formula
  include Language::Python::Virtualenv

  desc "Provider-agnostic pull request reviewer with keyless cloud auth"
  homepage "https://lgtmaybe.coles.codes/"
  url "https://files.pythonhosted.org/packages/96/64/ba2541cdb6d6aaba274ea4c968628a96176c265a1598cefe94b054718eed/lgtmaybe-1.10.0.tar.gz"
  sha256 "43309c06e6f57252903fa314838ed13af244b95900b6751ea217db1c4e8762bb"
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
