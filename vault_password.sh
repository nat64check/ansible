#!/bin/bash

# Try the macOS keystore
passwd=$(security find-generic-password -s ansible_nat64check -w 2>/dev/null)

# If nothing found then ask
if [ -z "$passwd" ]; then
	# Save the original terminal settings
	stty_orig=$(stty -g)

	# Automatically restore them when we abort
	trap "stty $stty_orig" SIGINT SIGTERM

	# Disabling echo of input
	stty -echo

	# Ask for the password
	echo -n "Vault password: " >&2
	read passwd 2>/dev/null
	echo 2>/dev/null

	# Restore terminal settings
	stty $stty_orig
fi

# And echo the password for Ansible to use
echo $passwd 2>/dev/null
