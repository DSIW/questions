# Question

Ask human a question. She or he has to select one answer.

## Installation

Add this line to your application's Gemfile:

    gem 'questions'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install questions

## Usage

### Preamble
``` ruby
require "questions"
include Questions
```

### Long way
``` ruby
q = Question.new("File does exist, what should be done?")
q.answers = [:skip, :overwrite, :abort]
answer = q.ask
# SHELL:
# $ File does exist, what should be done? [s]kip, [o]verwrite, [a]bort
# s<enter>
answer #=> :skip
```

### Short way
``` ruby
answer = Question.ask "File does exist, what should be done?", [:skip, :overwrite, :abort]
# SHELL:
# $ File does exist, what should be done? [s]kip, [o]verwrite, [a]bort
# s<enter>
answer #=> :skip
```

# It's also possible to specify answers as an Hash:

### Hashish way
``` ruby
answer = Question.ask "File does exist, what should be done?", skip: true, overwrite: false, abort: true
# SHELL:
# $ File does exist, what should be done? [s]kip, [a]bort
# s<enter>
answer #=> :skip
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
