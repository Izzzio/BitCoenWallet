
set -e

rm -Rf build

mkdir -p build

mkdir -p build/core
cp -Rf frontend build/core/frontend
cp -Rf modules build/core/modules
cp -f main.js build/core/main.js
cp -f Blockchain.js build/core/Blockchain.js
cp -f package.json build/core/package.json

cd shell

npm install electron

rm -Rf build
mkdir -p build

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    electron-packager . BitcoenWallet --platform=linux --icon=logo.ico --out=build --overwrite
elif [[ "$OSTYPE" == "darwin"* ]]; then
    electron-packager . BitcoenWallet --platform=darwin --icon=logo.ico --out=build --overwrite --version=0.35.6 --app-bundle-id="com.bitcoen.bitcoenwallet" --app-version="1.0.0" --build-version="1.0.000" --osx-sign
    electron-packager . BitcoenWalletUnsigned --platform=darwin --icon=logo.ico --out=build --overwrite
elif [[ "$OSTYPE" == "msys" ]]; then
     electron-packager . BitcoenWallet --platform=win32 --icon=logo.ico --out=build --overwrite
else
     electron-packager . BitcoenWallet --platform=all --icon=logo.ico --out=build --overwrite
fi

cp -Rf build/* ../build/

cd ../build/core

npm install

if [[ "$OSTYPE" == "msys" ]]; then
    cp -f ../../buildBinary/node.exe ./node.exe
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    cd ..
    cp -R core BitcoenWallet-darwin-x64/BitcoenWallet.app/Contents/Resources/app/
    cp -f ../buildBinary/node_darwin BitcoenWallet-darwin-x64/BitcoenWallet.app/Contents/Resources/app/core/node
    chmod 777 BitcoenWallet-darwin-x64/BitcoenWallet.app/Contents/Resources/app/core/node
    electron-osx-sign  BitcoenWallet-darwin-x64/BitcoenWallet.app    


    rm -Rf ../installers/BitcoenWallet.app
    cp -R BitcoenWallet-darwin-x64/BitcoenWallet.app ../installers/
    cd ../installers/
    rm -f BitcoenWallet-darwin-x64.dmg
    appdmg dmg.json BitcoenWallet-darwin-x64.dmg
    codesign -s "Developer ID Application: Viacheslav Semenchuk" ./BitcoenWallet-darwin-x64.dmg

    rm -rf .pkg
    mkdir -p .pkg
    cp -R BitcoenWallet.app .pkg
    rm -f BitcoenWalletComponents.plist
    pkgbuild --analyze --root .pkg BitcoenWalletComponents.plist
    /usr/libexec/PlistBuddy -c 'set :0:BundleIsRelocatable false' BitcoenWalletComponents.plist
    pkgbuild --root .pkg --install-location "/Applications" --sign "Developer ID Installer: Viacheslav Semenchuk" --component-plist BitcoenWalletComponents.plist BitcoenWallet.pkg

    cd ../build/
    cp -R core BitcoenWalletUnsigned-darwin-x64/BitcoenWalletUnsigned.app/Contents/Resources/app/
    cp -f ../buildBinary/node_darwin BitcoenWalletUnsigned-darwin-x64/BitcoenWalletUnsigned.app/Contents/Resources/app/core/node
    chmod 777 BitcoenWalletUnsigned-darwin-x64/BitcoenWalletUnsigned.app/Contents/Resources/app/core/node

    rm -Rf ../installers/BitcoenWalletUnsigned.app
    cp -R BitcoenWalletUnsigned-darwin-x64/BitcoenWalletUnsigned.app ../installers/
    cd ../installers/
    rm -f BitcoenWalletUnsigned-darwin-x64.dmg
    appdmg dmg.json BitcoenWalletUnsigned-darwin-x64.dmg
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cd ..
    cp -f ../buildBinary/node_linux core/node
    chmod 777 core/node
fi

rm -rf ../dumb

sleep 10
