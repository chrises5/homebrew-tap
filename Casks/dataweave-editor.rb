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

  caveats <<~EOS
    DataWeave Editor requires the DataWeave CLI (dw).
    Install it with:
      brew tap mulesoft/data-weave-cli
      brew install dw

    First launch: macOS may block the app because it is not code-signed.
    To fix, run this once after installing:
      xattr -cr "/Applications/DataWeave Editor.app"
    Then open the app normally.
  EOS

  zap trash: [
    "~/Library/Application Support/dataweave-editor",
    "~/Library/Preferences/com.kws.dataweave-editor.plist",
  ]
end
