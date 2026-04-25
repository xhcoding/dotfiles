

<div align="center">
  <h2>个人配置管理</h2>
  <p>一种跨不同机器管理系统配置文件的简单方法</p>
</div>

# 个人配置文件

## 📋 概览

个人配置文件存储库，用于在不同机器上存储和管理系统配置文件。此存储库提供了一种结构化的方式来组织、版本控制和部署各种应用程序和系统设置的配置文件。

## 📁 包含内容

此存储库包含以下目录组织的配置文件：

- **user/**: 用户特定的配置文件（例如 `~/.config/nvim/`、`~/.bashrc`）
- **system/**: 系统范围的配置文件（例如 `/etc/nginx/nginx.conf`）
- **bin/**: 可执行脚本和文件
- **scripts/**: 各种实用脚本
- **template.conf.example**: 用于变量替换的模板配置

## 🚀 安装

### 步骤 1: 克隆存储库
```bash
git clone https://github.com/xhcoding/dotfiles dotfiles
cd dotfiles
```

### 步骤 2: 运行安装脚本
```bash
chmod +x install.sh
./install.sh
```

## 🛠️ 使用方法

### dotfiles 工具

`dotfiles` 工具可用于管理配置文件，具有以下命令：

#### 向存储库添加文件
```bash
dotfiles --add <path>
```

#### 应用配置文件到系统
```bash
# 应用所有配置文件
dotfiles --apply

# 应用特定文件（使用正则表达式模式）
dotfiles --apply "nvim"

# 干运行（预览更改）
dotfiles --apply --dry-run
```

#### 从原始位置更新文件
```bash
# 更新所有文件
dotfiles --update

# 干运行（预览更改）
dotfiles --update --dry-run
```

#### 显示模板配置
```bash
dotfiles --conf
```

#### 帮助
```bash
dotfiles --help
```

## 📄 模板配置

`template.conf` 文件允许您为配置文件定义变量替换。这对于敏感信息或特定于环境的设置特别有用。

### 如何使用 template.conf

1. **复制示例文件**：
   ```bash
   cp template.conf.example template.conf
   ```

2. **编辑 template.conf 文件** 设置实际值：

   ```conf
   # Condition  File Regex	Variable Name	Replacement Value
   # Condition:  返回 true 以满足条件，否则返回 false 的 shell 函数。默认为 true，意味着始终满足
   # File Regex:  用于匹配要替换的文件的正则表达式
   # Variable Name:  替换值中的变量名，用于在配置文件中引用变量
   # Replacement Value:  要替换的实际字符串

   # mihomo 订阅 URL
   true mihomo/config.yaml MIHOMO_SUBSCRIBE_URL YOUR_SUBSCRIBE_URL
   ```

3. **在配置文件中使用变量**：
   ```yaml
   # In mihomo/config.yaml
   subscription:
     url: ${MIHOMO_SUBSCRIBE_URL}
     interval: 3600
   ```

4. **应用配置**：
   ```bash
   dotfiles --apply
   ```

工具会在应用过程中自动将 `${VARIABLE_NAME}` 替换为 `template.conf` 中的相应值。

## 📁 目录结构

```
dotfiles/
├── bin/                # 可执行脚本和文件
│   └── dotfiles.sh     # Dotfiles 管理工具
├── scripts/            # 各种实用脚本
├── user/               # 用户特定的配置文件
├── system/             # 系统范围的配置文件
├── install.sh          # 安装脚本
├── template.conf.example # 模板配置示例
└── README.md           # 文档（此文件）
```

## 🔍 工作原理

- **文件组织**：来自 `/home/*/` 的文件存储在 `user/` 目录中，而来自其他位置的文件存储在 `system/` 目录中
- **备份**：应用时，现有文件会备份到 `backup/YYYYMMDD_HHMMSS/` 目录
- **权限**：系统文件使用 sudo 权限处理
- **模板替换**：配置文件中的变量根据 `template.conf` 设置进行替换

## 💾 备份

工具会在应用新配置文件之前自动创建现有配置文件的备份。备份存储在带有时间戳的 `backup/` 目录中，确保您在需要时始终可以回滚到以前的配置。

## 📄 许可证

本项目采用 MIT 许可证 - 有关详细信息，请参阅 [LICENSE](LICENSE) 文件。
