# encoding: utf-8

module Questions
  # Represents an answer.
  #
  # An answer has an indicator which will be used to detect which answer is selected by user. Indicators are the first
  # few letters of its instruction. User can identify an
  # indicator by its surrounded square brackets. After that the rest of the instruction will be displayed.
  #
  # Answers can be active or inactive. Only active ansers will be displayed, inactive ones will be hidden.
  # Answers can be special, then the indicator is in uppercase letters set.
  class Answer
    SPECIAL_ENDINGS = [:all]

    # Instantiates new Answer object.
    #
    # Only the first key value pair will be used.
    #
    # @param [Hash] answer_hash Key (instruction); value (activeness) is `true` or `false`.
    #
    # @example Hash with one item
    #   Answer.new({:overwrite => true}) #=> [o]verwrite
    #   Answer.new(:overwrite => true) #=> [o]verwrite
    #   Answer.new(:overwrite) #=> [o]verwrite
    #   Answer.new({:overwrite => false}) #=> ""
    #   Answer.new(:overwrite => false) #=> ""
    #   Answer.new({:overwrite => nil}) #=> ""
    #
    # @example Items of hash with more than one item will be ignored
    #   Answer.new({:overwrite => true, :overwrite_all => false}) #=> [o]verwrite
    #   Answer.new({:overwrite => true, :overwrite_all => true}) #=> [o]verwrite
    def initialize(*answer_hash)
      hash = answer_hash.first
      hash = {hash => true} if hash.is_a? Symbol

      unless [Hash, Symbol].any? { |class_name| hash.is_a? class_name }
        raise ArgumentError, "Parameter has to be a key-value-pair or a symbol"
      end

      array        = hash.first
      @instruction = array[0]
      @active      = array[1]
    end

    # Gets instruction
    #
    # @example Hash with one item
    #   Answer.new(overwrite: true).instruction #=> :overwrite
    #   Answer.new(overwrite: false).instruction #=> :overwrite
    attr_reader :instruction

    # Is answer active?
    #
    # @example Hash with one item
    #   Answer.new(overwrite: true).active? #=> true
    #   Answer.new(overwrite: false).active? #=> false
    #
    # @see {true?}
    def active?
      @active
    end
    alias :true? :active?

    # Is answer inactive?
    #
    # @example Hash with one item
    #   Answer.new(overwrite: true).inactive? #=> false
    #   Answer.new(overwrite: false).inactive? #=> true
    #
    # @see {false?}
    def inactive?
      !active?
    end
    alias :false? :inactive?

    # Sets indicator
    #
    # @example Hash with one item
    #   answer = Answer.new(overwrite: true)
    #   answer.indicator = :ov
    #   answer.indicator #=> :ov
    attr_writer :indicator

    # Gets indicator
    #
    # @example with true answer
    #   a = Answer.new(overwrite: true)
    #   a.indicator #=> :o
    #   a.indicator(2) #=> :ov
    #
    # @example with special true answer
    #   Answer.new(overwrite_all: true).indicator(2) #=> :OV
    #
    # @example with inactive answer
    #   Answer.new(overwrite: false).indicator #=> nil
    #
    # @example set indicator
    #   a = Answer.new(overwrite: true)
    #   a.indicator #=> :o
    #   a.indicator = :ov
    #   a.indicator #=> :ov
    def indicator(first_chars=1)
      return nil if inactive?
      return @indicator if @indicator
      indicator = instruction.to_s[0...first_chars]
      indicator.upcase! if special?
      indicator.to_sym
    end

    # Returns `true` if answer is special. Special answers are answers which ends with one of the {SPECIAL_ENDINGS}, `false` otherwise.
    def special?
      SPECIAL_ENDINGS.any? { |ending| instruction.to_s =~ /#{ending}$/ }
    end

    # Gets indicator hash
    #
    # @example Hash with one item
    #   Answer.new(overwrite: true).indicator_hash #=> {:o => :overwrite}
    #   Answer.new(overwrite: false).indicator_hash #=> nil
    def indicator_hash
      return nil if inactive?
      {indicator => instruction}
    end

    # Gets string representation
    #
    # @example Hash with one item
    #   Answer.new(overwrite: true).to_s #=> "[o]verwrite"
    #   Answer.new(overwrite: false).to_s #=> ""
    def to_s
      return nil if inactive?
      instruction_without_indicator = instruction.to_s[indicator.length..-1]
      humanized = instruction_without_indicator.gsub("_", " ")
      "[#{indicator}]#{humanized}"
    end
  end
end
