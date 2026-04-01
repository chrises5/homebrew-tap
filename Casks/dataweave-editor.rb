cask "dataweave-editor" do
  version "1.3.0"

  on_arm do
    sha256 "0f8e358a6c6a2ecab4e7548eb0ddd43b579f581bea4a86b4d5cfc6ea95c07e46"
    url "https://github.com/chrises5/dataweave-editor/releases/download/v#{version}/DataWeave.Editor-#{version}-arm64-mac.zip"
  end

  on_intel do
    sha256 "ad55e030070b2321435d81354fb300dd4d8b4f2d4db08e639d0b9e99f15b120c"
    url "https://github.com/chrises5/dataweave-editor/releases/download/v#{version}/DataWeave.Editor-#{version}-mac.zip"
  end

  name "DataWeave Editor"
  desc "Local DataWeave editor — run transformations with no size limits"
  homepage "https://github.com/chrises5/dataweave-editor"

  app "DataWeave Editor.app"

  postflight do
    # Install DataWeave CLI if not present
    unless File.exist?("/opt/homebrew/bin/dw") || File.exist?("/usr/local/bin/dw")
      ohai "Installing DataWeave CLI (dw)..."
      system_command "#{HOMEBREW_PREFIX}/bin/brew", args: ["tap", "mulesoft-labs/data-weave"]
      system_command "#{HOMEBREW_PREFIX}/bin/brew", args: ["install", "dw"]
    end
    # Sign app for macOS Gatekeeper
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/DataWeave Editor.app"]
    system_command "/usr/bin/find", args: [
      "#{appdir}/DataWeave Editor.app/Contents/Frameworks",
      "-type", "f", "-perm", "+111",
      "-exec", "/usr/bin/codesign", "--force", "--sign", "-", "{}", ";"
    ]
    system_command "/usr/bin/codesign", args: ["--force", "--deep", "--sign", "-", "#{appdir}/DataWeave Editor.app"]
  end

  zap trash: [
    "~/Library/Application Support/dataweave-editor",
    "~/Library/Preferences/com.chrises5.dataweave-editor.plist",
  ]
end
