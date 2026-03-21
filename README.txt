SimpleIdentity
(c) 2006 Travis Conway

A World of Warcraft Classic addon that prepends your guild and officer chat
messages with a custom identity tag. This makes it easy for guildmates to
know who you are across multiple characters.

Example: If your identity is set to "Travis", your guild chat will appear as:
  [Travis] Hey everyone!


INSTALLATION
------------
Copy the SimpleIdentity folder into your WoW addons directory:
  World of Warcraft/_classic_era_/Interface/AddOns/


COMMANDS
--------
All commands use the /simpleid slash command.

  /simpleid
    Show the list of available commands.

  /simpleid set <name>
    Set your identity tag. This is the text that will appear in brackets
    before your guild and officer chat messages.
    Example: /simpleid set Travis

  /simpleid server on
    Enable server mode. When enabled, all characters on your account on the
    current realm share the same identity tag. If you already have an identity
    set on the current character, it will be copied to the server-wide setting
    automatically.

  /simpleid server off
    Disable server mode. Each character will use its own individual identity
    tag instead of the shared server-wide one.

  /simpleid status
    Display your current settings, including server mode and active identity.


SERVER MODE
-----------
By default, each character has its own identity tag. Enabling server mode
shares a single identity across all characters on the same realm and account.
This is useful if you want the same tag on every alt without setting it
individually on each one.

Settings are saved automatically and persist across sessions.


LICENSE
-------
Released under the MIT License. See LICENSE.txt for details.
