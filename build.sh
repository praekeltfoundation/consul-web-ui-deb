#!/bin/bash -e

PROJECT="consul"
VERSION="0.6.0"
PLATFORM="web_ui"
BASE_URL="https://releases.hashicorp.com/$PROJECT/$VERSION"

INSTALL_DIR=/usr/share/consul-web
EMPTY_DIRS=( )

function download_release_file() {
    echo "Downloading file '$1'..."
    curl -s -o $1 "$BASE_URL/$1"
}

echo "Downloading signature files..."
SHA_FILE="${PROJECT}_${VERSION}_SHA256SUMS"
SHA_SIG_FILE="$SHA_FILE.sig"
download_release_file $SHA_FILE
download_release_file $SHA_SIG_FILE

echo "Verifying $SHA_FILE signature..."
gpg --verify $SHA_SIG_FILE

ZIP_FILE="${PROJECT}_${VERSION}_${PLATFORM}.zip"
if [ ! -f $ZIP_FILE ]; then
    download_release_file $ZIP_FILE
else
    echo "File $ZIP_FILE found, not downloading."
fi

echo "Verifying $ZIP_FILE hash..."
grep $ZIP_FILE $SHA_FILE > sha256sum.txt
sha256sum -c sha256sum.txt

# Hack sideloader to not build things in /var/praekelt - install files straight into the package directory
PACKAGE_DIR=$WORKSPACE/package
mkdir -p $PACKAGE_DIR
mkdir -p $PACKAGE_DIR$INSTALL_DIR

echo "Extracting $ZIP_FILE contents to $INSTALL_DIR in package..."
unzip -qo -d $PACKAGE_DIR$INSTALL_DIR $ZIP_FILE

# Create misc empty directories
for path in $EMPTY_DIRS; do
    mkdir -p $PACKAGE_DIR$path
done
