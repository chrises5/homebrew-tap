cask "dataweave-editor" do
  version "1.0.0"

  on_arm do
    sha256 "b13359059b152cf98ef1ed01c448ebcfb1b80bc77c77c1fd96d3007d94372542"
    url "https://github.com/chrises5/dataweave-editor/releases/download/v#{version}/DataWeave.Editor-#{version}-arm64-mac.zip"
  end

  on_intel do
    sha256 "eccc87412b7197dc905c599e2c59352ed6209c2a1ccda553004b35fd07a41db9"
    url "https://github.com/chrises5/dataweave-editor/releases/download/v#{version}/DataWeave.Editor-#{version}-x64-mac.zip"
  end

  name "DataWeave Editor"
  desc "Local DataWeave editor — run transformations with no size limits"
  homepage "https://github.com/chrises5/dataweave-editor"

  app "DataWeave Editor.app"

  postflight do
    # Install DataWeave CLI if not present
    unless File.exist?("/opt/homebrew/bin/dw") || File.exist?("/usr/local/bin/dw")
      ohai "Installing DataWeave CLI (dw)..."
      system_command "#{HOMEBREW_PREFIX}/bin/brew", args: ["tap", "mulesoft/data-weave-cli"]
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
