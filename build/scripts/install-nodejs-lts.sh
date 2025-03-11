# Install the latest LTS version of Node.js
echo "Installing the latest LTS version of Node.js..."
nvm install --lts

# Set the LTS version as default
nvm alias default 'lts/*'
nvm use default

# Verify installation
echo "Node.js installation complete!"
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# Add NVM setup to shell profile if not already added
if ! grep -q "NVM_DIR" ~/.bashrc; then
  echo "Adding NVM to shell profile (~/.bashrc)..."
  echo -e '\n# NVM (Node Version Manager) setup\nexport NVM_DIR="$HOME/.nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"\n[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
  echo "Added NVM setup to ~/.bashrc"
fi

echo "=== Node.js LTS installation completed successfully ==="
echo "To start using Node.js in the current session, either:"
echo "  1. Close and reopen your terminal"
echo "  2. Run: source ~/.bashrc"
