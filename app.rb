require 'bundler'
require 'nokogiri'
require 'open-uri'
require "google_drive"
Bundler.require

require './lib/scrapper'

Scrapper.new.perform