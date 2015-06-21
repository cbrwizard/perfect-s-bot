# perfect-s-bot
Hipchat bot which gets your butt in shape

Very inspired by [this](http://blog.ctrl.la/how-slackbot-forced-us-to-work-out/) article.

## How to set up:
1. Create a bot for your hipchat just like you create an ordinary account.
1. Visit [Hipchat integrations page](https://springboardretail.hipchat.com/account/addons) while logged in into your bot account. Copy your name (which is also a jid).
1. Create settings.yml from a settings_example.yml, paste your copied name there instead of example jid.
1. Write down your password there.
1. Also change status and room as you like.
1. Launch it in terminal `ruby app.rb`

It will connect to your chat as a newly created account, then it will login to that room. As soon as you can see it online, activate it by saying @YOUR_BOT_NAME_HERE start in chat.

Have fun!
