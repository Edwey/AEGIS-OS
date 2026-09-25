# AEGIS OS - Fish Shell Configuration

# 1. Set a clean, minimal greeting (disable the default Fish welcome)
set -g fish_greeting

# 2. Initialize Starship Prompt (The Cyberpunk Magic)
starship init fish | source

# 3. Custom Aliases for AEGIS OS
alias ll='ls -la --color=auto'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias neofetch='fastfetch' # Because we prefer fastfetch

# 4. Directory jumping (if we install z later, this prepares it)
# alias cd='z' 

# 5. AEGIS Welcome Message on new terminal
echo ""
echo (set_color cyan)"  Welcome to AEGIS OS."(set_color normal)
echo (set_color mauve)"  Stay secure. Stay sharp."(set_color normal)
echo ""