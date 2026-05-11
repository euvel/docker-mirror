#!/bin/bash
# Reassemble file from chunks

echo "🔧 Reassembling: tele-mirror-win-x64.zip"

# Combine all chunks
cat tele-mirror-win-x64.zip.part.* > tele-mirror-win-x64.zip

# Verify checksum
if sha256sum -c tele-mirror-win-x64.zip.sha256 --strict 2>/dev/null; then
    echo "✅ Success! File reassembled: tele-mirror-win-x64.zip"
    echo "Size: $(du -h tele-mirror-win-x64.zip | cut -f1)"
    echo ""
    echo "You can now delete the .part.* files to save space:"
    echo "rm tele-mirror-win-x64.zip.part.*"
else
    rm tele-mirror-win-x64.zip
    echo "❌ Checksum failed! File may be corrupted."
    exit 1
fi
