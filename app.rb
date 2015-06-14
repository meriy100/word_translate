require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
require './models/bookmark.rb'
require_relative "./translate"
require "./parsing_doc.rb"

get '/' do
  @words = Word.order "id DESC"
  #@words = Word.all
  @title = "Words table"
  erb :index
end


def line_translate line
  line.each do |word|
    word.downcase!
    unless @data =  Word.find_by(en: word)
      ja =  translate_goo_en_to_ja word
      sleep 0.5
      Word.create en: word, ja: ja, count: 1
    else
      @data.update( {count: @data.count + 1 })
    end
  end

end




post '/create' do
  list = parsing params[:text]
  list.each do |word|
    word.downcase!
    unless @data =  Word.find_by(en: word)
      ja =  translate_goo_en_to_ja word
      sleep 0.5
      Word.create en: word, ja: ja, count: 1
    else
      @data.update( {count: @data.count + 1 })
    end
  end
  redirect '/'
end

post '/tofile' do
  list = parsing_doc params[:file]
  list.each do |line|
    line_translate line
  end

  redirect '/'
end

post '/delete/:id' do
  Word.find(params[:id]).destroy
  redirect '/'
end

post '/to_hide/:id' do
  Word.find(params[:id]).update({hide: true})
  redirect '/'
end

post '/edit/:id' do
  @data = Word.find(params[:id])
  @title = "Edit #{@data.en}"
  erb :edit
end

post '/renew/:id' do
  @data = Word.find(params[:id])
  @data.update({
    en: params[:en],
    ja: params[:ja]
  })
  redirect '/'
end

=begin
get '/api/site' do
  html = Nokogiri::HTML.parse(open params[:url])
  title = html.css('title').text
  data = {title: title}
  json data
end
=end

#set :bind, '192.168.33.10'
#set :port, 3000
