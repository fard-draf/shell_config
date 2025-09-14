# ===================================================
#        FICHIER DE CONFIGURATION ZSH
# ===================================================
HOST_CONFIG_DIR="$HOME/.config/host_specific"

# Détermine le fichier d'environnement à charger en fonction du nom d'hôte.
case "$(hostname)" in
    'pve-dev')
        HOST_ENV_FILE="$HOST_CONFIG_DIR/pve-dev.env.sh"
        ;;
    'zaatar')
        HOST_ENV_FILE="$HOST_CONFIG_DIR/zaatar.env.sh"
        ;;
    *)
        HOST_ENV_FILE="$HOST_CONFIG_DIR/pve-dev.env.sh"
        ;;
        ;;
esac

# Source le fichier d'environnement s'il a été trouvé et est lisible.
if [ -f "$HOST_ENV_FILE" ]; then
    source "$HOST_ENV_FILE"
else
    echo "ERREUR : Fichier d'environnement '$HOST_ENV_FILE' introuvable." >&2
fi

# ======= OPTIMISATIONS DE PERFORMANCES =======
# Désactiver les mises à jour automatiques d'Oh My Zsh
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# ======= POWERLEVEL10K INSTANT PROMPT =======
# Doit rester près du début du fichier .zshrc
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ======= CONFIGURATION OH MY ZSH =======
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Réduit le nombre de plugins au minimum essentiel
plugins=(git docker vscode npm node rust)

# ======= OPTIMISATION DE L'AUTOCOMPLÉTION =======
# Cache agressif des complétions
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -c '%Y' ~/.zcompdump 2>/dev/null | date +'%j')" ]; then
  compinit
else
  compinit -C
fi

# ======= CHARGEMENT OH MY ZSH =======
source $ZSH/oh-my-zsh.sh

# ======= CONFIGURATION SUPPLÉMENTAIRE =======
if [ -f /etc/zshrc ]; then
  source /etc/zshrc
fi

# ======= SCRIPTS MODULAIRES BASHRC.D =======
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      source "$rc"
    fi
  done
fi
unset rc

# ======= CONFIGURATION DE POWERLEVEL10K =======
# Pour personnaliser le prompt, lancer `p10k configure` ou éditer ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ======= CHARGEMENT DES FICHIERS MODULAIRES =======

# Définir le chemin canonique en utilisant une fonction interne de Zsh (:A)
local main_zshrc_path="${ZDOTDIR:-$HOME}/.zshrc:A"

# 1. Charger les fichiers de configuration Zsh (tous les fichiers presents dans le dossier)
for config_file in "$DOTFILES/shell/zsh/"**/*.zsh; do
  # On utilise aussi ":A" ici pour la comparaison
  if [[ -f "$config_file" ]] && [[ "$config_file:A" != "$main_zshrc_path" ]]; then
    source "$config_file"
  fi
done
unset main_zshrc_path

# Créer les répertoires nécessaires
mkdir -p $DOTFILES/shell/zsh \
         $DOTFILES/shell/common \
         $DOTFILES/shell/env 
         
# Chargement des paths
if [[ -f $DOTFILES/shell/env/paths.env ]]; then
  source $DOTFILES/shell/env/paths.env
fi
# ================================================================
# SECTION FINALE : COMMANDES INTERACTIVES ET NON-INTERACTIVES
# ================================================================

# --- Commandes exécutées uniquement dans un terminal interactif ---
if [ -t 0 ]; then
  # 1. Changer le répertoire de démarrage
  if [[ -d "$DEV_ENV/warehouse" ]]; then
    cd "$DEV_ENV/warehouse"
  fi

  # 2. Corriger le caractère d'effacement du terminal
  stty erase '^?'
fi

# --- Commandes pouvant être exécutées dans tous les contextes ---

# Gestion des secrets
if [[ -f "$DOTFILES/shell/common/.secrets" ]]; then
  source "$DOTFILES/shell/common/.secrets"
fi

# Gestion de l'agent SSH
SYSTEMD_AGENT_SOCK="/run/user/$(id -u)/ssh-agent.socket"
if [[ -S "$SYSTEMD_AGENT_SOCK" ]]; then
  export SSH_AUTH_SOCK="$SYSTEMD_AGENT_SOCK"
fi
#=======================================================
#         PROMPT
#=======================================================
PROMPT='%F{cyan}%n@%m%f %F{yellow}%~%f %# '
# --- Fin du fichier .zshrc ---
