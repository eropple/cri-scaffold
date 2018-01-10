# Cri::Scaffold

[Cri](https://github.com/ddfreyne/cri) is a pretty great tool. But using it can
be a bit of a pain sometimes, especially if you have deeply structured commands.
Cri::Scaffold exists to provide a convention-over-configuration method of
defining commands. It intentionally limits the options available--every project
using Cri::Scaffold works exactly the same, every time. In a nutshell:

- The root command is always `cli.rb`.
- Subcommands are in the `cli/` directory and end in `.cli.rb`,
  i.e. `cli/foo.cli.rb`, which will be defined as the `foo` subcommand.
- Sub-subcommands (and so on and so forth) are defined in directories descending
  from the name of the command, i.e. `foo bar` would be in `cli/foo/bar.rb`.
- Any command with an underscore in the name is converted to a hyphen to remove
  the "is it an underscore or is it a hyphen?" question. Hyphens are cool. We
  use hyphens.

Hat-tip to my friend [Sean Edwards](https://github.com/seanedwards) for the
idea.

## Usage
Cri::Scaffold expects to be pointed at a directory containing a file called
`cli.rb`. It returns acompletely configured `Cri::Command` that can be evaluated
with `ARGV`:

```rb
#! /usr/bin/env ruby
require 'cri/scaffold'

Cri::scaffold(File.expand_path("#{__dir__}/../lib/somegem")).run(ARGV)
```

The contents of `cli.rb`, and any sub-commands, will be evaluated as a DSL,
as if they were included inside of a `Cri::Command` block. There are two
important differences when writing the root command:

- The command is created with `Cri::Command.new_basic_root`, not instantiated
  directly via `Cri::Command.new`.
- The variable `program_name` is in scope, containing
  `File.basename($PROGRAM_NAME)`, to ensure a predictable help file text.

## Development
After checking out the repo, run `bin/setup` to install dependencies. You can
also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on GitHub at
https://github.com/eropple/cri-scaffold. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct
Everyone interacting in the Cri::Scaffold project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/eropple/cri-scaffold/blob/master/CODE_OF_CONDUCT.md).
