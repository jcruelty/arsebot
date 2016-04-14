#!/usr/bin/env ruby

require 'slack-ruby-bot'
require_relative 'lcs'

class ArseBot < SlackRubyBot::Bot
  command 'ping' do |client, data, match|
    client.say(text: 'pong', channel: data.channel)
  end

  match /tacos/ do |client, data, match|
    client.say(text: "DID SOMEONE SAY TACOS?!?!?! mmm mmm", channel: data.channel)
  end

  match /^lcs (?<user1>\w*) (?<user2>\w*)$/ do |client, data, match|
    # today lookup usernames of cur user, all other users, use those
    sequence = lcs(match[:user1], match[:user2])

    client.say(text: "#{sequence} (#{sequence.size})",
               channel: data.channel)
  end
end

ArseBot.run