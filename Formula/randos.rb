# Homebrew formula for the randos terminal client. Rendered from
# packaging/homebrew/randos.rb.template in the randos repo by
# `just homebrew-formula VERSION`; don't edit the rendered copy by hand.
class Randos < Formula
  desc "Anonymous, audio-only language practice with strangers, in your terminal"
  homepage "https://randos.slowinput.org"
  license "AGPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/wasichu/randos/releases/download/v0.11.0/randos-0.11.0-macos-arm64.tar.gz"
      sha256 "f8cb05c7779f38747a510a9fb5c8f92cdfac88881ad62c20c139169191542241"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/wasichu/randos/releases/download/v0.11.0/randos-0.11.0-linux-x86_64.tar.gz"
      sha256 "95a3d853c43a9d532d0503f5476bc9ad936fab0f2cdca3dcc9d67b7ba821d54e"
    end

    # What the release links (checked on the CI build, Ubuntu 24.04, so
    # glibc 2.39 or newer): ALSA for the media helper, OpenSSL 3 for
    # Erlang's crypto, ncurses (libtinfo) and zlib for the VM.
    depends_on "alsa-lib"
    depends_on "ncurses"
    depends_on "openssl@3"
    depends_on "zlib"
  end

  def install
    # A self-contained release (ERTS, the app, the media helper); bin/randos
    # follows its symlink back here.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/randos"
  end

  def caveats
    <<~EOS
      randos uses your microphone. On macOS the first call asks for mic
      access for your terminal app.
    EOS
  end

  test do
    assert_match "randos #{version}", shell_output("#{bin}/randos --version")
    # The media helper starts and answers (no audio device is opened).
    assert_match "audio helper: ok", shell_output("#{bin}/randos --check")
  end
end
