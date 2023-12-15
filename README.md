# Wezterm Configuration

Largely based on the config in but altered to match what I want: https://git.sr.ht/~zpm/wezterm

To deploy, you can run the following PowerShell:
```
cd ~
git clone https://github.com/strottos/wezterm-conf .wezterm
New-Item -Path ./.wezterm.lua -ItemType SymbolicLink -Value ./.wezterm/.wezterm.lua
```
or bash, similarly:
```
cd ~
git clone https://github.com/strottos/wezterm-conf .wezterm
ln -s .wezterm/.wezterm.lua ./.wezterm.lua
```
