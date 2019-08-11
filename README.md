# Garry's Mod Workstop

Workstop is a Garry's Mod plugin that will disable the tabs "Dupes" and "Saves"
in the Spawn Menu. Licensed under the [GNU General Public License
v3](LICENSE.md).

## Why?
This plugin was made because of the annoyance a lot of server admins have with
the stuff that's on the workshop (specifically the high number of crappy
dupes).

The plugin will hook into the spawn menu before it is generated and will
override the dupes and saves tab, showing only an HTML page, which URL can be
customized.

Note that to disable or enable this plugin, you'll have to restart your server.

## Configuration
The plugin will automatically override the tabs, the only configuration you can
do is defining it's content.

You can use the convar `workshop_disable_url` to set your own URL, or
leave it as-is for the default page (which will be as simple as it is now).

Please note that you have to put the URL within quotes, so you'd call something
like this:

```
workshop_disable_url "http://example.com/blocked.html"
```

The webpage is fully interactive, so you can put buttons there or even include
your forum.

## How to use
Simply add this addon to the collection you  use for the
`host_workshop_collection` launch flag on your server.

## How _not_ to use
Because some server owners look like they've got a really hard time
understanding text, I've made a little list:

- Do **not** add the addon to the clients download list
- Do **not** add the addon to your "resource collections" on the workshop
- Do **not** add the addon to another addon clients will subscribe to
- Do **not** ask your users to subscribe to this addon (yes, this happened)

Doing one of the aforementioned things, means you'll deserve a special mention
on the great Leaderboard of Dumb Server Owners™. It'll also upset your players
who suddenly see 'unavailable' warnings added to their workshop when they play
Single Player / Listen server games (or on servers that allow client-side lua).

## Found bugs?
Please create an issue if you found a bug.

## Final warning

**This addon is ment exclusively for server operators. Use on clients is highly
discouraged.**

**Please see [this article about the addon][1] if this addon is causing you, as a player, trouble.**

[1]: https://steamcommunity.com/groups/themodifiedgamers/announcements/detail/907843576939606963
