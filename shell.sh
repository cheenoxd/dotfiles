#!/bin/bash

echo "Running dotfiles setup..."

REPO_URL="https://github.com/cheenoxd/dotfiles.git"
CLONE_DIR="$HOME/dotfiles"

# Clone dotfiles repo if not present
if [ ! -d "$CLONE_DIR" ]; then
  echo "Cloning dotfiles repository..."
  git clone "$REPO_URL" "$CLONE_DIR"
else
  echo "Dotfiles repo already exists at $CLONE_DIR"
fi

cd "$CLONE_DIR" || { echo "Failed to enter $CLONE_DIR"; exit 1; }

# Install Homebrew if missing
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install core tools
echo "Installing core tools..."
brew install yabai zsh git

# Install Oh My Zsh (unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed"
fi

# Start yabai service
echo "Starting yabai window manager..."
brew services start yabai

# Install yabai config
echo "Installing yabai config..."
cp ./yabairc ~/.yabairc
chmod +x ~/.yabairc

# Install Powerlevel10k theme
echo "Installing Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install iTerm2
echo "Installing iTerm2..."
brew install --cask iterm2

# Install iTerm2 profile
echo "Installing iTerm2 profile..."
mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
cp ./iterm/profile.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/dotfiles-profile.json"

# Back up and set up .zshrc
if [ -f ~/.zshrc ]; then
  echo "Backing up existing .zshrc to .zshrc.backup"
  cp ~/.zshrc ~/.zshrc.backup
fi

echo "Linking new .zshrc..."
cp ./zshrc ~/.zshrc

# Apply VS Code settings
echo "Applying VS Code settings..."
mkdir -p "$HOME/Library/Application Support/Code/User"
cp ./vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"

# Reinstall VS Code extensions
echo "Installing VS Code extensions..."
xargs -n 1 code --install-extension < ./vscode/extensions.txt

# Reload zsh config
echo "Sourcing .zshrc..."
source ~/.zshrc

echo "Setup complete."
