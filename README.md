# GSPB - GNOME Settings & Packages Backups
A comprehensive, colorized backup tool for GNOME desktop settings and multiple package managers across major Linux distributions.

## ✨ Features

- 🖥️ **GNOME Settings Backup** – Complete GNOME desktop configuration backup using `dconf`
- 📦 **Multi-Package Manager Support** – Automatically detects installed native package managers
- 🎨 **Colorized Output** – Clean and visually appealing terminal output
- 🔧 **Cross-Distribution Compatibility** – Supports Ubuntu, Fedora, Arch, openSUSE, Gentoo, macOS, and more
- 📁 **Flexible Backup Locations** – Choose where backups are stored
- ⚡ **Fast & Lightweight** – Pure Bash script with minimal dependencies

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

---

## 🚀 Installation

### Quick Install
```bash
curl -o gspb.sh https://raw.githubusercontent.com/stefan-hacks/gspb/main/gspb.sh
chmod +x gspb.sh
sudo mv gspb.sh /usr/local/bin/gspb
```

---

## 📖 Usage

### Basic Usage
```bash
# Backup everything (default)
gspb

# Backup to a custom directory
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

---

## 🎯 Examples

### Complete System Backup
```bash
gspb --all
```
*Backs up GNOME settings, native packages, Flatpaks, Snaps, Homebrew, and Cargo packages.*

### Dev Environment Backup
```bash
gspb --gnome --flatpak --cargo
```
*Ideal for developers: saves GNOME settings, Flatpak apps, and Rust tools.*

### Minimal Backup
```bash
gspb --gnome --native
```
*Backs up essential system settings and packages.*

---

## 📊 Output Example
```text
GSPB - GNOME Settings & Packages Backups
Starting backup process to: 📁 /home/user/backups

ℹ ⚙ Backing up GNOME settings...
✓ ⚙ GNOME settings backed up to 📄 gnome_settings.bak

ℹ 📦 Backing up apt packages...
✓ 📦 APT packages backed up to 📄 apt_packages.bak

ℹ 📦 Backing up Flatpak applications...
✓ 📦 Flatpak applications backed up to 📄 flatpaks_list.bak

ℹ 🦀 Backing up Cargo/Rust packages...
✓ 🦀 Cargo packages backed up to 📄 cargo_packages.bak

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

### APT (Debian/Ubuntu)
```bash
sudo apt update
xargs -a apt_packages.bak sudo apt install
```

### Pacman (Arch)
```bash
xargs -a pacman_packages.bak sudo pacman -S
```

### Flatpak Applications
```bash
xargs -a flatpaks_list.bak flatpak install
```

### Homebrew (Not Recommended)
```bash
xargs -a brew_list.bak brew install
```

### Homebrew (Recommended Brewfile)
```bash
brew bundle install --file $HOME/backups/Brewfile
```

### Cargo Packages
```bash
xargs -a cargo_packages.bak cargo install
```

---

## 🛠️ Compatibility

| Distribution | Native PM | GNOME | Flatpak | Snap | Cargo |
|--------------|-----------|-------|---------|------|-------|
| **Ubuntu**   | ✅ APT    | ✅ | ✅ | ✅ | ✅ |
| **Debian**   | ✅ APT    | ✅ | ✅ | ⚠️ | ✅ |
| **Fedora**   | ✅ DNF    | ✅ | ✅ | ✅ | ✅ |
| **Arch**     | ✅ Pacman | ✅ | ✅ | ⚠️ | ✅ |
| **openSUSE** | ✅ Zypper| ✅ | ✅ | ⚠️ | ✅ |
| **Gentoo**   | ✅ Emerge | ✅ | ✅ | ❌ | ✅ |
| **macOS**    | ✅ Brew  | ❌ | ⚠️ | ❌ | ✅ |

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to your branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License
This project is licensed under the **MIT License**. See the `LICENSE` file for more details.

---

**Made with ❤️ for the Linux community**

