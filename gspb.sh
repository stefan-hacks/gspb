#!/usr/bin/env bash

# GSPB - GNOME Settings & Packages Backups
# A comprehensive backup tool for GNOME settings and package managers

# Configuration
BACKUP_DIR="$HOME/backups"
ERRORS=0

# Colors and symbols
RED=$(tput setaf 1 2>/dev/null || echo '')
GREEN=$(tput setaf 2 2>/dev/null || echo '')
YELLOW=$(tput setaf 3 2>/dev/null || echo '')
BLUE=$(tput setaf 4 2>/dev/null || echo '')
MAGENTA=$(tput setaf 5 2>/dev/null || echo '')
CYAN=$(tput setaf 6 2>/dev/null || echo '')
BOLD=$(tput bold 2>/dev/null || echo '')
RESET=$(tput sgr0 2>/dev/null || echo '')

SUCCESS="${GREEN}✓${RESET}"
FAILURE="${RED}✗${RESET}"
WARNING="${YELLOW}⚠${RESET}"
INFO="${BLUE}ℹ${RESET}"
FOLDER="${CYAN}📁${RESET}"
FILE="${BLUE}📄${RESET}"
PACKAGE="${MAGENTA}📦${RESET}"
SETTINGS="${YELLOW}⚙${RESET}"
RUST="${RED}🦀${RESET}"

# Detect system and default package manager
detect_package_manager() {
  if command -v apt &>/dev/null; then
    echo "apt"
  elif command -v pacman &>/dev/null; then
    echo "pacman"
  elif command -v dnf &>/dev/null; then
    echo "dnf"
  elif command -v yum &>/dev/null; then
    echo "yum"
  elif command -v zypper &>/dev/null; then
    echo "zypper"
  elif command -v emerge &>/dev/null; then
    echo "emerge"
  else
    echo "unknown"
  fi
}

NATIVE_PM=$(detect_package_manager)

# Colorized help message
print_help() {
  cat <<EOF
${BOLD}${CYAN}GSPB - GNOME Settings & Packages Backups${RESET}

${BOLD}Usage:${RESET} gspb [OPTIONS]

${BOLD}${GREEN}Options:${RESET}
  ${YELLOW}-i, --install${RESET}         Create backup directory structure
  ${YELLOW}-o, --output-dir DIR${RESET}  Specify custom backup directory (default: $BACKUP_DIR)
  ${YELLOW}-g, --gnome${RESET}           Backup GNOME desktop settings
  ${YELLOW}-n, --native${RESET}          Backup native packages (${NATIVE_PM})
  ${YELLOW}-f, --flatpak${RESET}         Backup Flatpak applications
  ${YELLOW}-b, --brew${RESET}            Backup Homebrew packages
  ${YELLOW}-s, --snap${RESET}            Backup Snap packages
  ${YELLOW}-c, --cargo${RESET}           Backup Cargo/Rust packages
  ${YELLOW}-A, --all${RESET}             Backup all systems (default if no options specified)
  ${YELLOW}-h, --help${RESET}            Show this help message

${BOLD}${GREEN}Examples:${RESET}
  gspb --all                      # Backup everything
  gspb --native --flatpak         # Backup only native and Flatpak packages
  gspb --output-dir /custom/path  # Use custom backup directory

If no backup options are specified, --all is assumed.
EOF
}

# Backup functions
backup_gnome() {
  local backup_file="${BACKUP_DIR}/gnome_settings.bak"

  if ! command -v dconf &>/dev/null; then
    echo "${WARNING} ${YELLOW}dconf not found - skipping GNOME settings backup${RESET}"
    return 1
  fi

  echo "${INFO} ${SETTINGS} Backing up GNOME settings..."
  if dconf dump / >"${backup_file}" 2>/dev/null; then
    echo "${SUCCESS} ${SETTINGS} GNOME settings backed up to ${FILE}${backup_file}${RESET}"
    return 0
  else
    echo "${FAILURE} ${SETTINGS} Failed to backup GNOME settings${RESET}"
    return 1
  fi
}

backup_native_packages() {
  local backup_file="${BACKUP_DIR}/${NATIVE_PM}_list.bak"

  echo "${INFO} ${PACKAGE} Backing up ${NATIVE_PM} packages..."

  case $NATIVE_PM in
  "apt")
    if command -v apt-mark &>/dev/null; then
      # Use apt-mark to get manually installed packages for cleaner restoration
      if apt-mark showmanual | sort >"${backup_file}" 2>/dev/null; then
        echo "${SUCCESS} ${PACKAGE} APT manually installed packages backed up to ${FILE}${backup_file}${RESET}"
        return 0
      fi
    fi
    ;;
  "pacman")
    if command -v pacman &>/dev/null; then
      if pacman -Qq >"${backup_file}" 2>/dev/null; then
        echo "${SUCCESS} ${PACKAGE} Pacman packages backed up to ${FILE}${backup_file}${RESET}"
        return 0
      fi
    fi
    ;;
  "dnf" | "yum")
    if command -v "$NATIVE_PM" &>/dev/null; then
      if $NATIVE_PM list installed --quiet >"${backup_file}" 2>/dev/null; then
        echo "${SUCCESS} ${PACKAGE} ${NATIVE_PM^^} packages backed up to ${FILE}${backup_file}${RESET}"
        return 0
      fi
    fi
    ;;
  "zypper")
    if command -v zypper &>/dev/null; then
      if zypper --quiet packages --installed-only >"${backup_file}" 2>/dev/null; then
        echo "${SUCCESS} ${PACKAGE} Zypper packages backed up to ${FILE}${backup_file}${RESET}"
        return 0
      fi
    fi
    ;;
  "emerge")
    if command -v emerge &>/dev/null; then
      if emerge -ep world >"${backup_file}" 2>/dev/null; then
        echo "${SUCCESS} ${PACKAGE} Emerge packages backed up to ${FILE}${backup_file}${RESET}"
        return 0
      fi
    fi
    ;;
  *)
    echo "${WARNING} ${YELLOW}Unknown or unsupported package manager: ${NATIVE_PM}${RESET}"
    return 1
    ;;
  esac

  echo "${FAILURE} ${PACKAGE} Failed to backup ${NATIVE_PM} packages${RESET}"
  return 1
}

backup_flatpak() {
  local backup_file="${BACKUP_DIR}/flatpak_list.bak"

  if ! command -v flatpak &>/dev/null; then
    echo "${WARNING} ${YELLOW}flatpak not found - skipping Flatpak applications backup${RESET}"
    return 1
  fi

  echo "${INFO} ${PACKAGE} Backing up Flatpak applications..."
  if flatpak list --app --columns=application >"${backup_file}" 2>/dev/null; then
    echo "${SUCCESS} ${PACKAGE} Flatpak applications backed up to ${FILE}${backup_file}${RESET}"
    return 0
  else
    echo "${FAILURE} ${PACKAGE} Failed to backup Flatpak applications${RESET}"
    return 1
  fi
}

backup_brew() {
  local backup_file="${BACKUP_DIR}/brew_list.bak"
  local brewfile_dir="$HOME/dotfiles/backups"
  local brewfile="${brewfile_dir}/Brewfile"

  if ! command -v brew &>/dev/null; then
    echo "${WARNING} ${YELLOW}brew not found - skipping Homebrew backup${RESET}"
    return 1
  fi

  echo "${INFO} ${PACKAGE} Backing up Homebrew packages..."
  if brew list -1 >"${backup_file}" 2>/dev/null; then
    echo "${SUCCESS} ${PACKAGE} Homebrew packages backed up to ${FILE}${backup_file}${RESET}"

    # Additional Brew bundle dump (keep Brewfile name as is)
    if [ -d "$brewfile_dir" ]; then
      if cd "$brewfile_dir" && rm -f "$brewfile" && brew bundle dump; then
        echo "${SUCCESS} ${PACKAGE} Brew bundle dumped to ${FILE}${brewfile}${RESET}"
      else
        echo "${WARNING} ${YELLOW}Failed to create Brew bundle${RESET}"
      fi
    fi
    return 0
  else
    echo "${FAILURE} ${PACKAGE} Failed to backup Homebrew packages${RESET}"
    return 1
  fi
}

backup_snap() {
  local backup_file="${BACKUP_DIR}/snap_list.bak"

  if ! command -v snap &>/dev/null; then
    echo "${WARNING} ${YELLOW}snap not found - skipping Snap packages backup${RESET}"
    return 1
  fi

  echo "${INFO} ${PACKAGE} Backing up Snap packages..."
  if snap list | awk 'NR>1{print $1}' >"${backup_file}" 2>/dev/null; then
    echo "${SUCCESS} ${PACKAGE} Snap packages backed up to ${FILE}${backup_file}${RESET}"
    return 0
  else
    echo "${FAILURE} ${PACKAGE} Failed to backup Snap packages${RESET}"
    return 1
  fi
}

backup_cargo() {
  local backup_file="${BACKUP_DIR}/cargo_list.bak"

  if ! command -v cargo &>/dev/null; then
    echo "${WARNING} ${YELLOW}cargo not found - skipping Cargo/Rust packages backup${RESET}"
    return 1
  fi

  echo "${INFO} ${RUST} Backing up Cargo/Rust packages..."
  if cargo install --list | grep -E '^[a-zA-Z0-9_-]+ v[0-9]' | cut -d' ' -f1 >"${backup_file}" 2>/dev/null; then
    echo "${SUCCESS} ${RUST} Cargo packages backed up to ${FILE}${backup_file}${RESET}"
    return 0
  else
    echo "${FAILURE} ${RUST} Failed to backup Cargo packages${RESET}"
    return 1
  fi
}

# Argument parsing
PARSED_ARGS=$(getopt -o "hi:o:gnfbscA" --long help,install,output-dir:,gnome,native,flatpak,brew,snap,cargo,all -- "$@") || exit 1
eval set -- "$PARSED_ARGS"

# Default backup flags
do_gnome=0
do_native=0
do_flatpak=0
do_brew=0
do_snap=0
do_cargo=0
do_all=1

while true; do
  case "$1" in
  -i | --install)
    mkdir -p "$BACKUP_DIR"
    echo "${SUCCESS} ${FOLDER} Created backup directory: ${BOLD}${BACKUP_DIR}${RESET}"
    exit 0
    ;;
  -o | --output-dir)
    BACKUP_DIR="$2"
    shift 2
    ;;
  -g | --gnome)
    do_gnome=1
    do_all=0
    shift
    ;;
  -n | --native)
    do_native=1
    do_all=0
    shift
    ;;
  -f | --flatpak)
    do_flatpak=1
    do_all=0
    shift
    ;;
  -b | --brew)
    do_brew=1
    do_all=0
    shift
    ;;
  -s | --snap)
    do_snap=1
    do_all=0
    shift
    ;;
  -c | --cargo)
    do_cargo=1
    do_all=0
    shift
    ;;
  -A | --all)
    do_all=1
    shift
    ;;
  -h | --help)
    print_help
    exit 0
    ;;
  --)
    shift
    break
    ;;
  *)
    echo "${FAILURE} Invalid option"
    exit 1
    ;;
  esac
done

# Main backup process
echo "${BOLD}${CYAN}GSPB - GNOME Settings & Packages Backups${RESET}"
echo "${BOLD}Starting backup process to: ${FOLDER}${BACKUP_DIR}${RESET}"
mkdir -p "$BACKUP_DIR"

if [[ $do_all -eq 1 ]]; then
  do_gnome=1
  do_native=1
  do_flatpak=1
  do_brew=1
  do_snap=1
  do_cargo=1
fi

((do_gnome)) && { backup_gnome || ERRORS=$((ERRORS + 1)); }
((do_native)) && { backup_native_packages || ERRORS=$((ERRORS + 1)); }
((do_flatpak)) && { backup_flatpak || ERRORS=$((ERRORS + 1)); }
((do_brew)) && { backup_brew || ERRORS=$((ERRORS + 1)); }
((do_snap)) && { backup_snap || ERRORS=$((ERRORS + 1)); }
((do_cargo)) && { backup_cargo || ERRORS=$((ERRORS + 1)); }

# Final status
echo
if [[ $ERRORS -eq 0 ]]; then
  echo "${SUCCESS} ${BOLD}${GREEN}All backups completed successfully!${RESET}"
  echo "${INFO} ${FOLDER} Backup directory: ${BOLD}${BACKUP_DIR}${RESET}"

  # List all backup files created
  echo "${INFO} ${FILE} Backup files created:"
  for backup_file in "$BACKUP_DIR"/*.bak; do
    if [[ -f "$backup_file" ]]; then
      echo "  ${FILE} $(basename "$backup_file")"
    fi
  done
  # Also list Brewfile if it exists
  if [[ -f "$HOME/dotfiles/backups/Brewfile" ]]; then
    echo "  ${FILE} Brewfile"
  fi

  exit 0
else
  echo "${FAILURE} ${BOLD}${RED}Backup completed with $ERRORS error(s)${RESET}"
  exit 1
fi
