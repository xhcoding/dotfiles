# ========================
# 路径配置
# ========================
export PATH=~/.cargo/bin:~/.local/bin:$PATH

# ========================
# 历史记录配置
# ========================
HISTFILE=~/.zsh_history    # 历史记录文件路径
HISTSIZE=100000            # 内存中保留的历史条数
SAVEHIST=$HISTSIZE         # 文件中保存的历史条数（与内存一致）

setopt append_history              # 会话结束时追加到历史文件（而非覆盖）
setopt inc_append_history          # 每条命令执行后立即写入历史文件（防丢失）
setopt extended_history            # 每条记录附带时间戳和耗时
setopt hist_expire_dups_first      # 历史超限时优先删除重复条目，保留唯一命令
setopt hist_ignore_all_dups        # 全局去重：新条目与旧条目重复时删除旧条目
setopt hist_ignore_dups            # 连续重复的命令不记录（仅忽略相邻重复）
setopt hist_ignore_space           # 以空格开头的命令不记入历史（适合输入密码等敏感操作）
setopt share_history               # 多个终端会话实时共享历史记录

# ========================
# Zinit 插件管理器初始化
# ========================
# Zinit 安装目录，优先使用 XDG_DATA_HOME，否则默认 ~/.local/share
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# 如果目录不存在则创建
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
# 如果尚未克隆仓库则浅克隆（--depth 1 仅拉取最新提交，加快速度）
[ ! -d $ZINIT_HOME/.git ] && git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# 加载 Zinit
source "${ZINIT_HOME}/zinit.zsh"

# ========================
# 补全系统初始化
# ========================
autoload -Uz compinit
# .zcompdump 文件若已存在且超过 24 小时，则用 -C 跳过安全检查以加速启动；
# 否则执行完整 compinit 以重建补全缓存
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit -C
else
    compinit
fi

# ========================
# 插件加载（Turbo 模式）
# ========================
# zsh-autosuggestions：根据历史和补全自动建议命令
#   - wait lucid：延迟加载（首次提示符出现后异步加载），lucid 抑制加载提示信息
#   - atload：加载完成后立即启动建议引擎（! 表示执行后进行调查报告）
#   - atinit：加载前初始化配置——策略为"先查历史再查补全"，限制建议触发的最大缓冲区长度为 20 字符，启用异步模式
zinit ice wait lucid \
    atload'!_zsh_autosuggest_start' \
    atinit'ZSH_AUTOSUGGEST_STRATEGY=(history completion); ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20; ZSH_AUTOSUGGEST_USE_ASYNC=1'
zinit light zsh-users/zsh-autosuggestions

# zsh-syntax-highlighting：命令语法高亮（正确命令绿色，错误命令红色等）
#   - 建议放在最后加载，以便捕获前面插件定义的关键字和命令
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# ========================
# 外部工具集成
# ========================
# Starship 跨 shell 提示符主题——仅在 starship 命令存在时加载
(( $+commands[starship] )) && eval "$(starship init zsh)"

# Zoxide 智能 cd 替代——学习你的目录使用习惯，用 z 命令快速跳转
(( $+commands[zoxide] ))   && eval "$(zoxide init zsh)"

# ========================
# fzf 模糊搜索配置
# ========================
if (( $+commands[fzf] )); then
    # 加载 fzf 自带的 zsh 集成（Ctrl-T 文件搜索、Ctrl-R 历史搜索、Alt-C 目录跳转）
    source <(fzf --zsh)

    # 全局 fzf 外观与行为
    export FZF_DEFAULT_OPTS="
        --height 40%                              # 占终端高度 40%
        --layout=reverse                          # 结果列表从上往下排列（输入框在顶部）
        --border                                  # 显示边框
        --info=inline                             # 匹配数信息内联显示
        --bind 'ctrl-y:execute-silent(echo {} | xclip -selection clipboard)+abort'  # Ctrl-Y 复制选中项到剪贴板并退出
    "

    # Ctrl-R 历史搜索专用选项
    export FZF_CTRL_R_OPTS="
        --preview 'echo {2..}'                    # 右侧预览面板显示完整命令（跳过序号字段）
        --preview-window down:3:hidden:wrap        # 预览窗口默认隐藏，位于底部，3 行高
        --bind 'ctrl-/:toggle-preview'             # Ctrl-/ 切换预览面板显隐
        --no-sort                                  # 保持历史时间顺序，不按相关性重排
    "
fi

# ========================
# 别名
# ========================
alias ls="eza"   # 用 eza 替代 ls（更现代的 ls，支持图标、Git 状态等）
alias cd="z"     # 用 zoxide 的 z 命令替代 cd（基于频率智能跳转目录）
