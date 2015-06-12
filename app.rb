require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require "sinatra/json"
require './models/bookmark.rb'
require_relative "./translate"
require "./parsing_doc.rb"

#test
get '/' do
  @bookmarks = Bookmark.all
  @title = "Words table"
  erb :index
end

post '/create' do
  list = parsing params[:text]
  list.each do |word|
    unless @data =  Bookmark.find_by(en: word)
      ja =  translate_goo_en_to_ja word 
      sleep 0.5
      Bookmark.create en: word, ja: ja, count: 1 
    else
      @data.update( {count: @data.count + 1 })
    end
  end
  redirect '/'
end

post '/delete/:id' do
  Bookmark.find(params[:id]).destroy
  redirect '/'
end

post '/to_hide/:id' do
  Bookmark.find(params[:id]).update({hide: true})
  redirect '/'
end

post '/edit/:id' do
  @data = Bookmark.find(params[:id])
  @title = "Edit #{@data.en}"
  erb :edit
end

post '/renew/:id' do
  @data = Bookmark.find(params[:id])
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
