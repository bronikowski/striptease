#Striptease - dead simple webcomic client
#2013 Mathilda Hartnell <nekkoru@gmail.com>
#https://github.com/nekkoru/striptease

require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-sqlite-adapter'

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/devel.db")

class Strip
  include DataMapper::Resource
  property :id,       Serial
  property :title,    String, :required => true
  property :posted,   DateTime
  property :filename, String, :required => true
  property :blurb,  Text
end

DataMapper.finalize

get '/' do
  @strip = Strip.last
  @prev = Strip.get(:id.lt => @strip.id, :limit => 1 )
  erb :index, :locals => { :strip => @strip, :prev => @prev }
end

get '/archive' do
  @strips = Strip.all
  erb :archive, :locals => { :strips => @strips }
end

get '/:id' do
  @strip = Strip.get(params[:id])
  @prev = Strip.get(:id.lt => @strip.id, :limit => 1 )
  @next = Strip.get(:id.gt => @strip.id, :limit => 1 )
  erb :strip, :locals => { :strip => @strip, :next => @next, :prev => @prev }
end


