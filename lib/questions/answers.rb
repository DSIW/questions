# encoding: utf-8

module Questions
  # Answers manages many answers. Each item is a Answer object in this collection.
  class Answers < Array
    # Instantiates a new Answers object.
    #
    # @param args [Answer, Symbol, Array, Hash] Initial answers
    #
    # Each parameter will be send to {#<<}.
    #
    # @example parameter as Answer
    #   answers = Answers.new Answer.new(:abort)
    #   answers.first.instruction #=> :abort
    #   answers.first.active #=> true
    #
    # @example parameter as Symbol
    #   answers = Answers.new :abort
    #   answers.first.instruction #=> :abort
    #   answers.first.active #=> true
    #
    # @example parameter as Array
    #   answers = Answers.new [:abort, Answer.new(:overwrite)]
    #   answers.first.instruction #=> :abort
    #   answers.first.active #=> true
    #   answers.last.instruction #=> :overwrite
    #   answers.last.active #=> true
    #
    # @example parameter as Hash
    #   answers = Answers.new({abort: true, overwrite: false, "non-symbol" => "ignored"})
    #   answers.size #=> 2
    #   answers.first.instruction #=> :abort
    #   answers.first.active #=> true
    #   answers.last.instruction #=> :overwrite
    #   answers.last.active #=> false
    def initialize(*args)
      args.each { |arg| self << arg }
    end

    # Adds answer. Answer can be an instance of {Answer}, {Symbol}, a {Hash} or an {Array}. Chaining is
    # supported.
    #
    # @example parameter as Answer
    #   answers = Answers.new
    #   answers << Answer.new(:abort)
    #   answers.first.instruction #=> :abort
    #   answers.first.active #=> true
    #
    # @example parameter as Symbol
    #   answers = Answers.new
    #   answers << :abort << :overwrite
    #   answers.first.instruction #=> :abort
    #   answers.first.active #=> true
    #   answers.last.instruction #=> :overwrite
    #   answers.last.active #=> true
    #
    # @example parameter as Array
    #   answers = Answers.new
    #   answers << [:abort, Answer.new(:overwrite)]
    #   answers.first.instruction #=> :abort
    #   answers.first.active #=> true
    #   answers.last.instruction #=> :overwrite
    #   answers.last.active #=> true
    #
    # @example parameter as Hash
    #   answers = Answers.new
    #   answers << {abort: true, overwrite: false, "non-symbol" => "ignored"}
    #   answers.size #=> 2
    #   answers.first.instruction #=> :abort
    #   answers.first.active #=> true
    #   answers.last.instruction #=> :overwrite
    #   answers.last.active #=> false
    #
    # @return [Answers] self
    def <<(arg)
      case arg
      when Answer then super arg
      when Symbol then super Answer.new(arg)
      when Array
        arg.each { |arg| self << arg } # call as Answer or Symbol
      when Hash
        self << convert_hash_to_answers(select_symbols(arg)) # call as Array
      end
      self
    end

    # Gets answer by indicator.
    #
    # @example
    #   answers = Answers.new [:abort, :overwrite]
    #   answers[:a].instruction #=> :abort
    #   answers[:o].instruction #=> :overwrite
    #
    # @return [Answer]
    def [](indicator)
      update_indicators_for_uniqueness!
      select { |answer| answer.indicator == indicator }.first
    end

    # Updates indicators to get all unique.
    #
    # @example
    #   answers = Answers.new [:abort, :abort_all, :abc]
    #   answers.indicators #=> [:a, :A, :a]
    #   answers.has_unique_indicators? #=> false
    #   answers.update_indicators_for_uniqueness!
    #   answers.indicators #=> [:a, :A, :ab]
    #   answers.has_unique_indicators? #=> true
    def update_indicators_for_uniqueness!
      return if has_unique_indicators?

      each_with_index do |answer, i|
        other_indicators = first(i).map(&:indicator)
        answer.indicator = free_indicator_of(answer, used_indicators: other_indicators)
      end
    end

    # Gets all indicators of answers.
    #
    # @example
    #   answers = Answers.new [:abort, :abort_all, :abc]
    #   answers.indicators #=> [:a, :A, :a]
    #   answers.update_indicators_for_uniqueness!
    #   answers.indicators #=> [:a, :A, :ab]
    def indicators
      map(&:indicator)
    end

    # Returns true if indicators are unique, false otherwise.
    #
    # @example
    #   answers = Answers.new [:abort, :abort_all, :abc]
    #   answers.indicators #=> [:a, :A, :a]
    #   answers.has_unique_indicators? #=> false
    #   answers.update_indicators_for_uniqueness!
    #   answers.indicators #=> [:a, :A, :ab]
    #   answers.has_unique_indicators? #=> true
    def has_unique_indicators?
      indicators = indicators()
      indicators == indicators.uniq
    end

    # Returns all answers as choice string.
    #
    # @example with only true answers
    #   answers = Answers.new [:abort, :abort_all, :abc]
    #   answers.choice_string #=> "[a]bort, [A]bort all, [ab]c"
    #
    # @example with false answer
    #   answers = Answers.new {abort: true, abort_all: false, abc: true}
    #   answers.choice_string #=> "[a]bort, [ab]c"
    def to_s
      update_indicators_for_uniqueness!
      map(&:to_s).compact.join(", ")
    end

    private

    # {"abc" => true, abort: true, overwrite: false} => {abort: true}
    def select_symbols(args)
      args.select { |inst, value| inst.is_a?(Symbol) }
    end

    # {abort: true} => [Answer.new(:abort => true)]
    def convert_hash_to_answers(answers)
      answers.reduce([]) { |array, (inst, value)| array << Answer.new({inst => value}) }
    end

    # :symbol => Answer.new(:symbol)
    # Answer.new(:symbol) => Answer.new(:symbol)
    # "string" => raise ArgumentError
    def convert_symbol_to_answer_or_send_through(arg)
      case arg
      when Answer then arg
      when Symbol then Answer.new(arg)
      else
        raise ArgumentError
      end
    end

    # Gets first free indicator for `answer` which isn't used by `used_indicators`.
    def free_indicator_of answer, opts={}
      opts = {:used_indicators => []}.merge(opts)
      used_indicators = opts[:used_indicators]

      i = 1
      loop do
        indicator = answer.indicator(i)
        if used_indicators.include? indicator
          i+=1
          redo # next try
        else
          return indicator
        end
      end
    end
  end
end
