#!/usr/bin/env bash

warn() { echo -e "$@" >/dev/stderr; }

# shellcheck disable=SC2034
{
    # Swift SDKs root path
    sdk_prefix=${SWIFT_PREFIX:-$(find /opt/homebrew/Cellar/swift/* | head -n 1)}

    # Swift SDK dirs and build tools (run find_tools to set them)
    xctoolchain=""
    swift_path=""
    swift_runtime_path=""
    swift=""
    swiftc=""
    sourcekit_lsp=""
    LLDB=""
}

# find all Swift SDKs dirs and build tools
find_tools() {
    xctoolchain="$(ls -d "$sdk_prefix"/Swift-*.xctoolchain)"
    swift_path="$xctoolchain/usr/bin"
    swift_runtime_path="$xctoolchain/usr/lib/swift/macosx"

    for p in sdk_prefix swift_path swift_runtime_path xctoolchain; do
        if test -d "${!p}"
        then warn "$p: ${!p}"
        else warn "$p not found at: /opt/homebrew/Cellar/swift/*"; return 1
        fi
    done

    if test -d "$sdk_prefix"
    then warn "Swift SDK: $sdk_prefix"
    else warn "Swift SDK not found at: /opt/homebrew/Cellar/swift/*"; return 1
    fi
    if test -d "$xctoolchain"
    then warn "Swift Toolchain: $xctoolchain"
    else warn "Swift Toolchain not found at: $sdk_prefix"; return 1
    fi

    for b in swift swiftc sourcekit-lsp LLDB; do
        local tool
        local var="${b//-/_}"
        if tool="$(find "$sdk_prefix" -name $b 2>/dev/null | head -n 1)" &&
           eval "$var='$tool'" &&
           test -n "$(eval "echo \$$var")"
        then warn "$b: $tool"
        else warn "Failed to set global var: $b"; return 1
        fi
    done
}

vscode_settings() {
    local f="$HOME/Library/Application Support/Code/User/settings.json"
    warn "\nCurrent VSCode Settings:\n"
    grep -E '^[ ]*"swift.*"' "$f" >/dev/stderr
    find_tools 1>/dev/null 2>/dev/null
    warn "\nSwift SDKs and Build Tools:\n"
    for v in sdk_prefix swift_path swift_runtime_path xctoolchain swift swiftc sourcekit_lsp LLDB; do
        printf "    %-20s ${!v}\n" "$v" >/dev/stderr
    done
    warn "\nAdd the following to your VSCode settings.json:"
    cat <<-EOF

    // Swift SDKs and Build Tools
    // ==========================
    "swift.runtimePath": "$swift_runtime_path",
    "swift.path": "$swift_path",
    "lldb.library": "$LLDB",
    "lldb.launch.expressions": "native",

EOF
}

usage () {
    cat <<-EOF
    Usage: $0 COMMAND"

    Commands:
        help    Show this help message (aliases: -h, --help)
        tools   Find all Swift SDKs dirs and build tools
        code    Show VSCode settings for Swift

    Environment Variables:
        SWIFT_PREFIX  Sets the path to Swift SDKs (value='$SWIFT_PREFIX'), leave empty to auto-detect.

EOF
}

case "$1" in
    tools|find)     find_tools ;;
    help|-h|--help) usage; exit 0 ;;
    code|vscode)    vscode_settings ;;
    *) echo "Usage: $0 tools" ;;
esac
