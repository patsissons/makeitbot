@echo off

REM Set your slack token here to connect the bot to your live slack team
REM You can find this on the Heroku settings tab (Config Variables)
SET HUBOT_SLACK_TOKEN=
SET HUBOT_YOUTUBE_API_KEY=
SET HUBOT_DARK_SKY_API_KEY=
SET HUBOT_DARK_SKY_DEFAULT_LOCATION=

node_modules\.bin\hubot.cmd --adapter slack
