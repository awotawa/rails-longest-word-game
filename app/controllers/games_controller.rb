# frozen_string_literal: true

# Class comment
class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times do
      @letters << alphabet.sample
    end
    @letters
  end

  def score
    @result = run_game(@word, @letters)
  end

  private

  def scoring(word_exist, in_the_grid, length)
    score = 0
    if word_exist && in_the_grid
      score = length * 10_000
      @message = 'Well done!'
    elsif word_exist && in_the_grid == false
      @message = 'Word not in the grid'
    else
      @message = 'Not an english word.'
    end
    "#{@message} You won #{score} points."
  end

  def checking(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    check = open(url).read
    check_jsoned = JSON.parse(check)
    check_jsoned
  end

  def in_the_grid?(attempt_array, grid)
    attempt_array.each do |letter|
      ind = grid.index(letter)
      if ind
        grid.delete_at(ind)
      else
        return false
      end
    end
    return true
  end

  def run_game(attempt, grid)
    check_jsoned = checking(attempt)
    attempt_array = attempt.split('')
    score = scoring(check_jsoned['found'], in_the_grid?(attempt_array, grid), check_jsoned['length'])
    score
  end
end
