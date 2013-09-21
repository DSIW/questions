# Question

Ask questions to humans. Somebody has to select one of the specified answers typing the character(s) in the square brackets.

## Installation

Add this line to your application's Gemfile:

    gem 'questions'

And then execute:

    $ bundle

Or install it via:

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

### Hashish way
``` ruby
answer = Question.ask "File does exist, what should be done?", skip: true, overwrite: false, abort: true
# SHELL:
# $ File does exist, what should be done? [s]kip, [a]bort
# s<enter>
answer #=> :skip
```

### Way with reaction
``` ruby
case Question.ask "Please select:", [:next, :exit]
when :next then next
when :exit then exit
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature-[short_description]` or `git checkout -b fix-[github_issue_number]-[short_description]`)
3. Commit your changes (`git commit -am 'Add some feature with tests'`)
4. Push to the branch (`git push origin [branch-name]`)
5. Create new Pull Request
