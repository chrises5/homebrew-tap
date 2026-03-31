cask "dataweave-editor" do
  version "1.1.0"

  on_arm do
    sha256 "2a2a1b775d2e71dea6c5597b00993aee8cae805835cacabce60424d58733a6ba"
    url "https://github.com/chrises5/dataweave-editor/releases/download/v#{version}/DataWeave.Editor-#{version}-arm64-mac.zip"
  end

  on_intel do
    sha256 "a23dba8de0ec89eb70cf80e6922ed7411b2969cdb24b579961a23d8ec036bfef"
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
