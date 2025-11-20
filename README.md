```markdown
# GSPB - GNOME Settings & Packages Backups

![GSPB Banner](https://img.shields.io/badge/GSPB-GNOME%20Settings%20%26%20Packages%20Backups-blue?style=for-the-badge)
![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

A comprehensive, colorized backup tool for GNOME desktop settings and multiple package managers across different Linux distributions.

## ✨ Features

- 🖥️ **GNOME Settings Backup** - Complete GNOME desktop configuration backup using dconf
- 📦 **Multi-Package Manager Support** - Automatic detection of native package managers
- 🎨 **Colorized Output** - Beautiful, easy-to-read terminal output with symbols
- 🔧 **Cross-Distribution** - Works on Ubuntu, Fedora, Arch, and other major distributions
- 📁 **Flexible Backup Locations** - Customizable output directories
- ⚡ **Fast & Lightweight** - Pure bash script with no dependencies

### Supported Package Managers

| Manager | Symbol | Description |
|---------|--------|-------------|
| **APT** | 📦 | Debian/Ubuntu packages |
| **Pacman** | 📦 | Arch Linux packages |
| **DNF/YUM** | 📦 | Red Hat/Fedora packages |
| **Zypper** | 📦 | openSUSE packages |
| **Emerge** | 📦 | Gentoo packages |
| **Flatpak** | 📦 | Flatpak applications |
| **Snap** | 📦 | Snap packages |
| **Homebrew** | 📦 | Linux/macOS packages |
| **Cargo** | 🦀 | Rust packages |

## 🚀 Installation

### Quick Install
```bash
curl -o gspb.sh https://raw.githubusercontent.com/stefan-hacks/gspb/main/gspb.sh
chmod +x gspb.sh
sudo mv gspb.sh /usr/local/bin/gspb
```

### Manual Installation
```bash
git clone https://github.com/stefan-hacks/gspb.git
cd gspb
chmod +x gspb.sh
sudo cp gspb.sh /usr/local/bin/gspb
```

## 📖 Usage

### Basic Usage
```bash
# Backup everything (default behavior)
gspb

# Backup with custom directory
gspb --output-dir /path/to/backups

# Install backup directory structure
gspb --install
```

### Selective Backups
```bash
# Backup only GNOME settings
gspb --gnome

# Backup native packages and Flatpaks
gspb --native --flatpak

# Backup specific package managers
gspb --brew --cargo

# Backup everything except Snap
gspb --gnome --native --flatpak --brew --cargo
```

### Full Options
```bash
gspb [OPTIONS]

Options:
  -i, --install         Create backup directory structure
  -o, --output-dir DIR  Specify custom backup directory (default: ~/backups)
  -g, --gnome           Backup GNOME desktop settings
  -n, --native          Backup native packages (auto-detected)
  -f, --flatpak         Backup Flatpak applications
  -b, --brew            Backup Homebrew packages
  -s, --snap            Backup Snap packages
  -c, --cargo           Backup Cargo/Rust packages
  -A, --all             Backup all systems (default)
  -h, --help            Show help message
```

## 🎯 Examples

### Complete System Backup
```bash
gspb --all
```
*Backs up GNOME settings, native packages, Flatpaks, Snaps, Homebrew, and Cargo packages*

### Development Environment Backup
```bash
gspb --gnome --flatpak --cargo
```
*Perfect for developers - saves desktop settings, Flatpak apps, and Rust tools*

### Minimal Backup
```bash
gspb --gnome --native
```
*Only essential system settings and packages*

## 📊 Output Example

```
GSPB - GNOME Settings & Packages Backups
Starting backup process to: 📁/home/user/backups

ℹ ⚙ Backing up GNOME settings...
✓ ⚙ GNOME settings backed up to 📄gnome_settings.bak

ℹ 📦 Backing up apt packages...
✓ 📦 APT packages backed up to 📄apt_packages.bak

ℹ 📦 Backing up Flatpak applications...
✓ 📦 Flatpak applications backed up to 📄flatpaks_list.bak

ℹ 🦀 Backing up Cargo/Rust packages...
✓ 🦀 Cargo packages backed up to 📄cargo_packages.bak

✓ All backups completed successfully!
ℹ 📁 Backup directory: /home/user/backups
ℹ 📄 Backup files created:
  📄 gnome_settings.bak
  📄 apt_packages.bak
  📄 flatpaks_list.bak
  📄 cargo_packages.bak
```
---
## 🔧 Restoration

### GNOME Settings
```bash
dconf load / < gnome_settings.bak
```

### APT Packages (Debian/Ubuntu)
```bash
sudo apt update
xargs -a apt_packages.bak sudo apt install
```

### Pacman Packages (Arch)
```bash
xargs -a pacman_packages.bak sudo pacman -S
```

### Flatpak Applications
```bash
xargs -a flatpaks_list.bak flatpak install
```

### Homebrew Packages (NOT RECOMMENDED)
```bash
xargs -a brew_list.bak brew install
```

### (RECOMMENDED OPTION) homebrew also creates A Brewfile
```bash
```brew bundle install --file $HOME/backups/Brewfile
```
```

### Cargo Packages
```bash
xargs -a cargo_packages.bak cargo install
```

## 🛠️ Compatibility

| Distribution | Native PM | GNOME | Flatpak | Snap | Cargo |
|--------------|-----------|-------|---------|------|-------|
| **Ubuntu** | ✅ APT | ✅ | ✅ | ✅ | ✅ |
| **Debian** | ✅ APT | ✅ | ✅ | ⚠️ | ✅ |
| **Fedora** | ✅ DNF | ✅ | ✅ | ✅ | ✅ |
| **Arch** | ✅ Pacman | ✅ | ✅ | ⚠️ | ✅ |
| **openSUSE** | ✅ Zypper | ✅ | ✅ | ⚠️ | ✅ |
| **Gentoo** | ✅ Emerge | ✅ | ✅ | ❌ | ✅ |
| **macOS** | ✅ Brew | ❌ | ⚠️ | ❌ | ✅ |

## 🤝 Contributing

We welcome contributions! Please feel free to submit pull requests, report bugs, or suggest new features.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Troubleshooting

### Common Issues

**"Command not found" errors**
- Ensure the package manager is installed on your system
- Some package managers might need additional setup

**Permission denied**
- Use `sudo` for system-wide package operations during restoration
- Ensure you have write permissions to the backup directory

**GNOME backup fails**
- Verify `dconf` is installed: `sudo apt install dconf-tools` (Ubuntu/Debian)

---

**Made with ❤️ for the Linux community**
```

