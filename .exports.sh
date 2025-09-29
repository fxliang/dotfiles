export PATH="$HOME/.local/bin:$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/:$HOME/.cargo/bin:$HOME/apps/node-v22.13.0-linux-x64/bin:$PATH"
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

export NVIM_BIN_PATH=$HOME/apps/nvim-linux-x86_64/bin
export LUA_LANGUAGE_SERVER_PATH=$HOME/apps/lua-language-server/bin
export ANDROID_HOME=~/android/sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$NVIM_BIN_PATH:$LUA_LANGUAGE_SERVER_PATH:$PATH
#export SDK_REPO_URL="https://repo.huaweicloud.com/android/repository/"
alias sdkmanager="~/android/sdk/cmdline-tools/latest/bin/sdkmanager"
export ADB_SERVER_SOCKET=tcp:$(grep -oP '(?<=nameserver\ ).*' /etc/resolv.conf):5037

#export DISPLAY=10.199.29.15:0.0
#export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
#export XDG_RUNTIME_DIR=/tmp/xdg-runtime-$USER

