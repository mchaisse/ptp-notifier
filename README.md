# PassThePopcorn Notifier

### Description

Script that will listen to Freeleech publications and post them to Slack.

_Note: the script is flexible enough so more listeners and more notification services can be added later on._

### How it works

The script will run every 30 minutes looking for new Freeleech publications. At first start, the script will _warm-up_ by caching the list of the current freeleech into Redis. This warm-up has been implemented to prevent flooding the Slack channel(s). From now on, each run will compare what has already been cached with the new publications. It will then send a notification on Slack with info and links.

Note that a Docker container has been created for a ready-to-use solution. Every time the container stops and restart, the redis db is reset and therefore none of the notifications will go through (the script will think it is a first time run).

### Dependencies

Mandatory:
- PassThePopcorn account
- Docker _(if using the docker image)_
- Redis server instance \*\*
- Cron \*\*
- Ruby 2.6 \*\*

Optional:
- Omdb account

_\*\* provided out-of-the-box in the Docker image_

### Getting started
Assuming all dependencies are already installed.

#### Docker
1. Build the image
`docker build -t ptp-notifier .`
2. Create a `.env` environment file (see [environment variables section](#environment-variables))
3. Run the container
`docker run --rm -it --env-file .env ptp-notifier`

Logs will be directly printed in the container output.

#### Manual
`MY_ENV=X MY_VAR=Y ruby run.rb`
_Do not forget to replace the environment variables. For more info: (see [environment variables section](#environment-variables)._

Logs can be seen at:
- cron logs: `tail -f /var/log/ptp-cron.log`
- script logs: `tail -f /var/log/ptp-notifier.log`

### Environment variables
| Key | Description | Default value | Required |
| ------------ | ------------ | ------------ | ------------ |
| PTP_USERNAME | PassThePopcorn username |  | **Yes** |
| PTP_PASSWORD | PassThePopcorn password |  | **Yes** |
| PTP_PASSKEY | PassThePopcorn passkey |  | **Yes** |
| SLACK_API_TOKEN | Slack bot token |  | **Yes** |
| OMDB_API_KEY | Open Movie Database API token. If not provided, ratings will be ignored |  | No |
| SLACK_FREELEECH_CHANNEL | Slack channel to post the new freeleech publications | freeleech | No |
| PTP_BASE | PassThePopcorn base url | https://passthepopcorn.me | No |
| PTP_LOGIN_REQUEST | PassThePopcorn login url | /ajax.php?action=login | No |
| PTP_LOGOUT_REQUEST | PassThePopcorn logout url | /logout.php | No |
| PTP_FREELEECH_REQUEST | PassThePopcorn freeleech url | /torrents.php?freetorrent=1&grouping=0&json=noredirect | No |
| PTP_TORRENT_REQUEST | PassThePopcorn movie url (it must include the movie id `${id}` and the specific publication id `${torrent_id}`) | /torrents.php?id=${id}&torrentid=${torrent_id} | No |
| PTP_ARTIST_REQUEST | PassThePopcorn artist/director url (it must include the id `${id}`) | /artist.php?id=${id} | No |
| PTP_TAG_REQUEST | PassThePopcorn tag url (it must include the name `${name}`) | /torrents.php?taglist=${name}&cover=1 | No |
| PTP_FREELEECH_DURATION | Duation of a freeleech. This is set the cache expiration time for each publication id. | 86400 | No |
| IMDB_URL | Internet Movie Database url for a movie (it must include the movie id `${id}`) | http://www.imdb.com/title/${id} | No |
| REDIS_URL | Redis url | redis://:localhost:6379 | No |
| DEVELOPER_MODE | Print more debug info (`true` to activate) |  | No |

### Filters
Filters can be created and applied for each new publication. If the filter has a match, the publication will be posted on the main `#freeleech` channel **and** on other specified ones. Each implemented filter is optional can be activated by filling an environment variable (avoid spaces in the name):

| Key | Description | Default value | Example value |
| ------------ | ------------ | ------------ | ------------ |
| SLACK_FREELEECH_4K_CHANNEL | 4K publication |  | freeleech-4k |
| SLACK_FREELEECH_BD_CHANNEL | Blu-ray publication |  | freeleech-bluray |
