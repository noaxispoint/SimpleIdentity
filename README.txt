SimpleIdentity v1.0.3
(c) 2026 Travis Conway

A World of Warcraft Classic addon that prepends your guild and officer chat
messages with a custom identity tag. This makes it easy for guildmates to
know who you are across multiple characters.

Example: If your identity is set to "MyName", your guild chat will appear as:
  [MyName] Hey everyone!


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
    Example: /simpleid set MyName

  /simpleid enable [on|off]
    Enable or disable the addon for the current character. If on or off is
    omitted, it toggles the current state. Useful for temporarily silencing
    the tag on a specific character without changing your identity settings.

  /simpleid server [on|off]
    Enable or disable server mode. If on or off is omitted, it toggles the
    current state. When enabled, all characters on your account on the current
    realm share the same identity tag. If you already have an identity set on
    the current character, it will be copied to the server-wide setting
    automatically.

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
