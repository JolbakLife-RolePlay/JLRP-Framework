# JLRP-Framework
A <b>WIP</b> framework for creating roleplay servers on FiveM. (Almost everything except gangs and live server closure work and tested!)

## Requirements

* Dependencies
  * <b>`Onesync Infinity`</b> to be set on
  * [resources/[gameplay]/chat](https://github.com/citizenfx/cfx-server-data)
  * [resources/[managers]/spawnmanager](https://github.com/citizenfx/cfx-server-data)
  * [resources/[system]/sessionmanager](https://github.com/citizenfx/cfx-server-data)
  * [oxmysql](https://github.com/overextended/oxmysql)

## Installation
- Import `JLRP-Framework.sql` to your database
- Add this to your `server.cfg` after chat, spawnmanager, sessionmanager, and oxmysql:

```
ensure JLRP-Framework
```
