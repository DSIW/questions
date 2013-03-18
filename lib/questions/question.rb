# encoding: utf-8

module Questions
  # You can ask a question with answers for selection. User can select one answer.
  #
  # @example Long way
  #   q = Question.new("File does exist, what should be done?")
  #   q.answers = [:skip, :overwrite, :abort]
  #   answer = q.ask
  #   # SHELL:
  #   # $ File does exist, what should be done? [s]kip, [o]verwrite, [a]bort
  #   # s<enter>
  #   answer #=> :skip
  #
  # @example Short way
  #   answer = Question.ask "File does exist, what should be done?", [:skip, :overwrite, :abort]
  #   # SHELL:
  #   # $ File does exist, what should be done? [s]kip, [o]verwrite, [a]bort
  #   # s<enter>
  #   answer #=> :skip
  #
  # It's also possible to specify answers as an Hash:
  #
  # @example Hashish way
  #   answer = Question.ask "File does exist, what should be done?", skip: true, overwrite: false, abort: true
  #   # SHELL:
  #   # $ File does exist, what should be done? [s]kip, [a]bort
  #   # s<enter>
  #   answer #=> :skip
  class Question
    attr_reader :question
    attr_reader :answers

    # Instantiates a new Question object.
    #
    # @param question [String] This message will be printed
    def initialize(question)
      @question = question
      @answers = Answers.new
    end

    # Sets answers
    #
    # @example
    #   q = Question.new("File does exist, what should be done?")
    #   q.answers = [:yes, :no]
    #   q.answers.size #=> 2
    #   q.answers.map(&:instruction) #=> [:yes, :no]
    #
    def answers=(*args)
      @answers.clear
      args.each { |arg| @answers << arg }
    end

    # Asks question to user. If user typed wrong indicator, then it will be asked again.
    #
    # @example without answers
    #   q = Question.new("What?")
    #   q.ask #=> raise Error
    #
    # @example with answers
    #   q = Question.new("What?")
    #   q.answers = [:yes, :no]
    #   q.ask #=> :yes if user typed 'y'
    #
    # @return [Symbol] selected answer
    def ask
      answers = answers()
      raise "You have to set answers" if answers.empty?
      answer = UserInput.get "#{@question} #{answers}"
      answers[answer.to_sym].instruction || ask
    end

    # Asks question.
    #
    # @param question [String] Message that will be printed
    # @param answers [Array, Hash] Answers that are displayed for selection
    #
    # @example
    #   Question.ask("What are you doing?", [:nothing, :cleaning_up])
    #   # SHELL:
    #   # $ What are you doing? [n]othing, [c]leaning up
    #   # n<enter>
    #   # => :nothing
    #
    # @example Question with answers as hash.
    #   ask("Do you have a problem?", :yes => true, :no => true)
    #
    # @return [Symbol] selected answer
    def self.ask(question, answers)
      question = Question.new(question)
      question.answers = answers
      question.ask
    end
  end
end
