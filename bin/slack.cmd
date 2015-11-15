@echo off

REM Set your slack token here to connect the bot to your live slack team
REM You can find this on the Heroku settings tab (Config Variables)
SET HUBOT_SLACK_TOKEN=

node_modules\.bin\hubot.cmd --adapter slack
