# `sidekiq-staged_push`

`sidekiq-staged_push` is an extension to [Sidekiq](http://github.com/mperham/sidekiq) that
implements a strategy of pushing jobs to Redis that involves an intermediary database table.
It is developed based on the approach described in [Transactionally Staged Job Drains in Postgres](https://brandur.org/job-drain). Quoting the author:

> With this pattern, jobs aren’t immediately sent to the job queue. Instead, they’re staged in
> a table within the relational database itself, and the ACID properties of the running
> transaction keep them invisible until they’re ready to be worked. A secondary enqueuer
> process reads the table and sends any jobs it finds to the job queue before removing their
> rows.

This allows you to leverage the power of Sidekiq while still treating your jobs as if they
were stored in the database for the purpose of transactions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-staged_push'
```

And then execute:

    $ bundle

In `config/initializers/sidekiq.rb`:

```ruby
Sidekiq::StagedPush.enable!
```


## Development

You need Docker with Docker Compose.

```
make build
make bundle
```

Then you can run:

```
make test
make rubocop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adamniedzielski/sidekiq-staged_push. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `sidekiq-staged_push` project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/adamniedzielski/sidekiq-staged_push/blob/master/CODE_OF_CONDUCT.md).
