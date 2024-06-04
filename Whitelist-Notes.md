# Notes

Just a quick file for me to note about some of the whitelist

- All usb modules are whitelisted. This can probably be restricted further.
- led whitelisting is probably not necessary, except for ledtrig_audio on Parallels.
- rc-core is needed for the Vostro, but this might just be a retro laptop thing.
- sony whitelisting is for vaio laptops, but they are not procuded by sony anymore, so...
- All snd modules are whitelisted. This can probably be restricted further.
- usb-storage, dm-, sparse-keymap, and rc-core have different names in /proc.