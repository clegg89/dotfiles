# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.2-3

# ~/.bash_profile: executed by bash(1) for login shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bash_profile

# Modifying /etc/skel/.bash_profile directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bash_profile) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bash_profile file

# Set PATH so it includes user's private bin if it exists
# if [ -d "${HOME}/bin" ] ; then
#   PATH="${HOME}/bin:${PATH}"
# fi

# Set MANPATH so it includes users' private man if it exists
# if [ -d "${HOME}/man" ]; then
#   MANPATH="${HOME}/man:${MANPATH}"
# fi

# Set INFOPATH so it includes users' private info if it exists
# if [ -d "${HOME}/info" ]; then
#   INFOPATH="${HOME}/info:${INFOPATH}"
# fi

# CVS variables
export CVSROOT=":ext:csmith@cvs.autani.local/home/cvs"
export CVS_RSH="ssh"

# Add extra paths
export PATH="${HOME}/.local/bin:${HOME}/.local/sbin:${PATH}"
export PATH="/cygdrive/c/Program Files (x86)/Ember/ISA3 Utilities/bin:${PATH}"
export PATH="/cygdrive/c/Program Files (x86)/Ember/xIde_EM250/SIF/bin:${PATH}"
export PATH="/cygdrive/c/Program Files (x86)/IAR Systems/Embedded Workbench 7.2/common/bin:${PATH}"
export PATH="/cygdrive/c/Program Files (x86)/Ember/xIDE_EM250/bin:${PATH}"

# Add extra man pages
MANPATH="${HOME}/.local/man:${MANPATH}"

# Add extra info path
INFOPATH="${HOME}/.local/info:${INFOPATH}"

# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

