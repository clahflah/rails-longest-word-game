require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    charset = Array('A'..'Z')
    @letters = Array.new(10) { charset.sample }
  end

  def score
    @response = params['response']
    @points = @response.length
    check = params['letters'].split()
    original = params['letters'].split()
    split_response = @response.split("")
    new_array = []
    copy_array = check
    split_response.each do |letter|
      new_array << letter.upcase
    end
    valid = []
    new_array.each do |letter|
      if check.include?(letter)
        valid << 'yes'
        check.delete_at(check.index(letter))
      end
    end
    filepath = "https://wagon-dictionary.herokuapp.com/#{@response}"
    serialized_score = URI.open(filepath).read
    @score_check = JSON.parse(serialized_score)
    if @score_check['found'] == false
      @comment = "Sorry #{@response} is not a valid english word."
    elsif @score_check['found'] == true && valid != [] && valid.length == new_array.length
      @comment = "Congratulations! #{@response} is a valid English word. Your final score is #{@points} points!"
    elsif @score_check['found'] == true
      @comment = "Sorry, #{@response} cannot be built out of #{original.join('')} #{check} #{new_array} #{split_response} #{valid}"
    end
  end
end
