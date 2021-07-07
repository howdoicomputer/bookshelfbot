# BookshelfBot

![bookshelfbot_example](https://user-images.githubusercontent.com/6774447/124696577-36c2d480-de9a-11eb-8722-9d15bc4795bb.png)

BookshelfBot is a Discord bot that fetches information for a book and then displays that information within a Discord message.

This bot was inspired by the [Reddit GoodReads Bot](https://github.com/rodohanna/reddit-goodreads-bot) that I found out about through [/r/suggestmeabook](https://old.reddit.com/r/suggestmeabook/). Unfortunately, I cannot use GoodReads as they're deprecating their API so I use Google Books instead.

### NOTE THIS IS BASICALLY ALPHA SOFTWARE

I wrote this in a night. It lacks tests. I'm a terrible Elixir developer If this breaks then I am sorry. Feel free to post an issue.

## [Add BookshelfBot to your Discord server](https://discord.com/api/oauth2/authorize?client_id=861069894648201228&permissions=2048&scope=bot%20applications.commands)

## Slash Commands

`/info` - Displays information about the bot
`/book <book_title>` - fetches information about a book using its title (this data comes from Google Books)

## How it Works

The bot is an OTP application that has two child applications: a GenStage 'consumer' provided by the Nostrum library that will receive data from Discord and act on it, and a Cachex process that will help enable response caching for returned API responses from Google Books. You can see these both started as children in `lib/bookshelf_bot/application.ex`.

The API wrapper for the Google Books service is in `lib/bookshelf_bot/google_books`. It is *very* simple and only wraps the `https://www.googleapis.com/books/v1/volumes` endpoint. This API wrapper is used by the main Discord consumer code to query for book information.

The code that actually handles Discord events is defined in `lib/bookshelf_bot_discord`. The consumer's behavior is defined in `lib/bookshelf_bot_discord/consumer.ex` (see the `handle_event` function matches).

The slash commands are defined individually in the `lib/bookshelf_bot_discord/slash_commands` and the code that pushes those commands to Discord as well as handle all incoming interactions with those commands are in `lib/bookshelf_bot_discord/slash_commands`. The book slash command caches API responses in accordance to the query string used to fetch them. So if someone searched for "Big Foot" as a book title then that string would be normalized to "big+foot" and then any returned book for that title would be stored in an in-memory cache so that subsequent API requests wouldn't have to be made.

## TODO

- I should probably add a `by <author>` feature for when two titles conflict.
- The Google Books API actually returns a collection of books and the bot just grabs the first one. This works for now because Google is really good about approximating which book is the most correct. If this causes problems down the road, then I'll have to figure out something more advanced.
- Typespecs are inconsistently applied throughout the project and Dialyzer isn't setup.
- There are literally no tests.

## Installation

- Set `DISCORD_TOKEN` within your shell.
- Create a `dev.secret.exs` file based on the `dev.secret.exs.example` file (that config points the bot at a test guild)
- `mix deps.get`
- `mix --no-halt`

That's the basics on running the bot locally against a dev Discord server.

The production deploy for this bot uses [fly.io]() as a host. It's a Heroku like PaaS that showed up on Hacker News once or twice so I checked them out. They have great documentation for onboarding an elixir application, have a really good free tier, and are super easy to use. The guide I used to deploy this application is [here](https://fly.io/docs/getting-started/elixir/#viewing-the-deployed-app) - it features deploying a Phoenix webapp but I found it easy enough to adapt.

## Resources

- [Botchini](https://github.com/lucapasquale/botchini): This existing elixir bot was what I started with as a base. I generated an OTP application with `mix new --app` and then took chunks out of botchini like a cannibalistic parasite. The code I took I clarified with comments and added some defensive programming. Very grateful it exists.
- [Nostrum](https://github.com/Kraigie/nostrum): The Discord library I used.
