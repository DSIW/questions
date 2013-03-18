# encoding: utf-8

module AnswersHelper
  # {"abc" => true, abort: true, overwrite: false} => {abort: true}
  def self.select_symbols(args)
    args.select { |inst, value| inst.is_a?(Symbol) }
  end

  # {abort: true} => [Answer.new(:abort => true)]
  def self.convert_hash_to_answers(answers)
    answers.reduce([]) { |array, (inst, value)| array << Answer.new({inst => value}) }
  end

  # :symbol => Answer.new(:symbol)
  # Answer.new(:symbol) => Answer.new(:symbol)
  # "string" => raise ArgumentError
  def self.convert_symbol_to_answer_or_send_through(arg)
    case arg
    when Answer then arg
    when Symbol then Answer.new(arg)
    else
      raise ArgumentError
    end
  end

  # Gets first free indicator for `answer` which isn't used by `used_indicators`.
  def self.free_indicator_of answer, opts={}
    opts = {:used_indicators => []}.merge(opts)
    used_indicators = opts[:used_indicators]

    first_chars = 1
    loop do
      indicator = answer.indicator(first_chars)
      if used_indicators.include? indicator
        first_chars += 1
        redo # next try
      else
        return indicator
      end
    end
  end
end
