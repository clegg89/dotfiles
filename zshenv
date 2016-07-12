#####################################
# Environment Variable Additions
#####################################

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ]; then
  PATH="${HOME}/bin:${PATH}"
fi

# Set MANPATH so it includes users' private man if it exists
if [ -d "${HOME}/man" ]; then
  MANPATH="${HOME}/man:${MANPATH}"
fi

# Set INFOPATH so it includes users' private info if it exists
if [ -d "${HOME}/info" ]; then
  INFOPATH="${HOME}/info:${INFOPATH}"
fi

#####################################
# User Local Extensions
#####################################
if [ -d "${HOME}/.local" ]; then

  # Set PATH so it includes user's private bin if it exists
  if [ -d "${HOME}/.local/bin" ]; then
    PATH="${HOME}/.local/bin:${PATH}"
  fi

  # Set PATH so it includes user's private sbin if it exists
  if [ -d "${HOME}/.local/sbin" ]; then
    PATH="${HOME}/.local/sbin:${PATH}"
  fi

  # Set MANPATH so it includes users' private man if it exists
  if [ -d "${HOME}/.local/man" ]; then
    MANPATH="${HOME}/.local/man:${MANPATH}"
  fi

  # Set INFOPATH so it includes users' private info if it exists
  if [ -d "${HOME}/.local/info" ]; then
    INFOPATH="${HOME}/.local/info:${INFOPATH}"
  fi

  # Source local user profile extensions
  if [ -d "${HOME}/.local/etc" ] && [ -f "${HOME}/.local/etc/zshenv" ]; then
    source "${HOME}/.local/etc/zshenv"
  fi
fi
