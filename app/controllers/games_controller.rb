class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }.join.chars
  end

  def score
    session[:total_score] = 0 unless session.key?(:total_score)
    @letters = (params[:token]).chars
    @word = (params[:word]).chars
    url = "https://wagon-dictionary.herokuapp.com/#{@word.join}"
    serialized_url = open(url).read
    @found = (JSON.parse(serialized_url))["found"]
    @match = @word.all? { |letter| @word.count(letter) <= @letters.count(letter) }
    if @match && @found
      @score = @word.length
      session[:total_score] += @score
    else
      @score = 0
      session[:total_score] += @score
    end
    if @match && @found
      @answer = "Congratulations! #{@word.join} is a valid English word!"
    elsif !@match
      @answer = "Sorry. #{@word.join} can't be built out of #{@letters.join}"
    elsif !@found
      @answer = "Sorry. #{@word.join} doesn't seem to be an English word."
    end
  end
end
