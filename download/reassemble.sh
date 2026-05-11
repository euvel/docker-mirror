#!/bin/bash
echo "🔧 Reassembling: tele-mirror-win-x64.zip"

# Combine chunks
cat "tele-mirror-win-x64.zip".part.* > "tele-mirror-win-x64.zip"

# Verify checksum
if command -v sha256sum >/dev/null 2>&1; then
    if sha256sum -c "tele-mirror-win-x64.zip".sha256 2>/dev/null; then
        echo "✅ Success! File: tele-mirror-win-x64.zip"
        echo "Size: $(du -h "tele-mirror-win-x64.zip" | cut -f1)"
        echo ""
        echo "🧹 Cleaning up chunks..."
        rm "tele-mirror-win-x64.zip".part.*
        echo "✅ Done! Only the final file remains."
    else
        rm "tele-mirror-win-x64.zip"
        echo "❌ Checksum verification failed!"
        exit 1
    fi
elif command -v shasum >/dev/null 2>&1; then
    expected=$(cut -d' ' -f1 < "tele-mirror-win-x64.zip.sha256")
    actual=$(shasum -a 256 "tele-mirror-win-x64.zip" | cut -d' ' -f1)
    if [ "$actual" = "$expected" ]; then
        echo "✅ Success! File: tele-mirror-win-x64.zip"
        echo "Size: $(du -h "tele-mirror-win-x64.zip" | cut -f1)"
        echo ""
        echo "🧹 Cleaning up chunks..."
        rm "tele-mirror-win-x64.zip".part.*
        echo "✅ Done! Only the final file remains."
    else
        rm "tele-mirror-win-x64.zip"
        echo "❌ Checksum verification failed!"
        exit 1
    fi
else
    echo "⚠️  No checksum tool found, skipping verification"
    echo "✅ File reassembled: tele-mirror-win-x64.zip"
    echo ""
    echo "🧹 Cleaning up chunks..."
    rm "tele-mirror-win-x64.zip".part.*
    echo "✅ Done! Only the final file remains."
fi
