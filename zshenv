#####################################
# Environment Variable Additions
#####################################

# Fix for if SHELL is somehow not properly set.
if [ "${SHELL}" != "/bin/zsh" ]; then
  export SHELL="/bin/zsh"
fi

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

# Remove PATHS in WSL
if uname -r | grep -q 'Microsoft'; then
  # Windows Subsystem for Linux (WSL)

  # Save the base Windows directory path
  windir=$(echo $PATH | tr ':' '\n' | grep 'Windows$')

  # Remove all windows PATHS and whitelist our own.
  while echo $PATH | grep -q '/mnt/[a-z]/'; do
    PATH=${PATH%:/mnt/[a-z]/*}
  done

  # Add back in our whitelist
  PATH="${PATH}:${windir}:${windir}/System32:${windir}/System32/wbem:${windir}/System32/WindowsPowerShell/v1.0"
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

export PATH
export MANPATH
export INFOPATH
