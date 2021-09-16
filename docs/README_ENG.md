# Slackyt


1. [About application](#about)
2. [Setting up](#setup)
3. [Local run](#local-run)
4. [Remote server deploy](#deploy)


## About <a id="about"></a>
The purpose of application is to connect slack threads to youtrack issue

### Example:

![Slack thread](slack-example-ru.png)

Превращается в

![Youtrack issue](yt-example-ru.png)

### Call syntax:
`{bot mention} {task id} {optional: thread description}`
## Setting up <a id="setup"></a>

1. [Create bot integration](https://my.slack.com/services/new/bot) and get slack API token
2. [Crate  YouTrack api token](https://www.jetbrains.com/help/youtrack/standalone/Manage-Permanent-Token.html)
3. Create file secret.exs in the config/ directory, fill in as shown in  config/secret.example.exs
4. Create field `Threads` in youtrack issue cards and allow users to edit it

## Local run <a id="local-run"></a>

### From source
Requirements:
- Elixir 1.12.3 (compiled with Erlang/OTP 24)

Steps:

1. Install dependencies: `mix deps.get`
2. Compile it `mix deps.compile`
3. Run server `mix run --no-halt`

### From docker container
Requirements:
- docker
- docker-compose
  
Steps:

In the current directory execute `docker-compose up`

## Remote server deploy <a id="deploy"></a>

Requirements: 
- Python 3.7

Steps:
1. Change working directody ansible
1. Install python poetry `python3 -m pip install poetry`
1. Activate virtual environment `python3 -m poetry shell`
1. Install dependencies `poetry install`
1. Create file hosts.ini containing your server address information as  `user@server-ip`
1. Create file variables.yml and fill it with local variables:
   ```
   user: user dir on server, bot_dir: directory where the application should be installed
   ```
  
   You can find the configuration examples in the ansible directory: variables.example.yml и hosts.example.ini
  
1. Run deploy by executing `ansible-playbook -i hosts.ini --extra-vars "@variables.yml"  deploy.yml`

Compilation on weak servers may take some time. It also requires at least 2Gb of Ram, so create a swap-file if 
you don't have enough