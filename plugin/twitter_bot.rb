# -*- encoding: utf-8 -*-
require 'twitter'
require 'userstream'
require 'clockwork'
require 'redis'
require 'pp'

class TwitterBot
  include Clockwork

  attr_reader :redis
  def initialize
    uri = URI.parse(REDIS_URI)

    @client = Twitter::Client.new(
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :oauth_token => ACCESS_TOKEN,
      :oauth_token_secret => ACCESS_TOKEN_SECRET
    )
    @timeline = []
    @timeline_since = 1
    @reply = []
    @reply_since = 1
  end

  def require_plugin(name)
    require "#{PLUGIN_ROOT}/#{name}"
    self.extend name.classify.constantize
  end

  def job(param = {})
    return unless param[:intval] && param[:func]

    every(param[:intval], param[:func].to_s, :at => param[:at] ? param[:at].to_s : nil) do
      self.send(param[:func])
    end
  end

  def hello
    puts "hello"
  end

  def get_timeline
    @timeline = @client.home_timeline :count => 200, :since_id => @timeline_since
    dump_statuses(@timeline)
  end

  def get_reply
    @reply = @client.mentions_timeline :count => 200, :since_id => @reply_since
    dump_statuses(@reply)
  end

  def dump_statuses(statuses)
    statuses.each do |status|
      dump_status status
    end
  end

  def dump_status(status)
    puts "--------------------------------"
    puts "@#{status['user']['screen_name']}(#{status['user']['name']}) at #{status['created_at']}"
    puts "#{status['text']}"
  end

  def update(msg)
    (defined? DEBUG) && DEBUG ?  puts(msg) : @client.update(msg)
    return msg
  end

  def favorite(status)
    return unless status.text
    (defined? DEBUG) && DEBUG ?  puts('favorite: ' + status.text) : @client.favorite(status.id)
  end

  def retweet(status)
    return unless status.text
    @client.retweet status.id
  end
end
