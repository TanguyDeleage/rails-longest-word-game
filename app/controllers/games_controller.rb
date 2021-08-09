require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    grid = ('A'..'Z').to_a
    @letters = []
    while @letters.size < 10
      @letters << grid.sample
    end
  end

  def score
    @grid = params[:grid]
    @answer = params[:word]
    if english_word? && used_letters?
      "GG"
    elsif english_word?
      "Tu n'as pas les bonnes lettres"
    elsif used_letters?
      "Ton mot n'existe pas"
    else
      "Rien ne va"
    end
  end

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    word_dictionary = open(url).read
    word = JSON.parse(word_dictionary)
    word['found']
  end

  def used_letters?
    attempt = @answer
    grid = @grid.split(' ')
    letters = attempt.upcase.chars
    letters.each do |letter|
      index = grid.index(letter)
      return false if index.nil?

      grid.delete_at(index)
    end
  end
end
