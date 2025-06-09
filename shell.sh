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

# Install iTerm2
echo "Installing iTerm2..."
brew install --cask iterm2

# Set up .zshrc
echo "Linking .zshrc..."
cp ./zshrc ~/.zshrc

# Reload zsh config
echo "Sourcing .zshrc..."
source ~/.zshrc



echo "Setup complete."
