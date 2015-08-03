# hubot-catfacts

Subscribe to Cat Facts! Thanks for using Cat Facts!

See [`src/catfacts.coffee`](src/catfacts.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-catfacts --save`

Then add **hubot-catfacts** to your `external-scripts.json`:

```json
[
  "hubot-catfacts"
]
```

Set `HUBOT_CATFACTS_FACTINTERVAL` manually if want. This determines how often cat facts are sent out. It uses cron syntax (incl. seconds) and defaults to `00 00 * * * *` (hourly).

## Sample Interaction

```
user1>> hubot catfact
```

Everything else is done via private message.

P.S. Don't cancel your Cat Facts subscription a second time ;)
