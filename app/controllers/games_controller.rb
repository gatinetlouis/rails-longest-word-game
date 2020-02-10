require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def generate_grid(grid_size)
    array_of_letters = ('A'..'Z').to_a
    number_of_letters = array_of_letters.length
    random_word = ''
    grid_size.times { random_word += array_of_letters[rand(number_of_letters)].to_s }
    random_word.split('')
  end

  def new
    @letters = generate_grid(10)
    session[:score] = 0 if session[:score].nil?
  end

  def array_included_in?(word, letters)
    letters_splitted = letters.split('')
    word_splitted = word.upcase.split('')
    one_condition = word_splitted.all? { |letter| letters_splitted.include?(letter) }
    another_condition = word_splitted.all? { |letter| word_splitted.count(letter) <= letters_splitted.count(letter) }
    one_condition && another_condition
  end

  def existing_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    JSON.parse(word_serialized)
end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @array_included_in = array_included_in?(@word, @letters)
    @existing_word = existing_word?(@word)["found"]
  end
end
