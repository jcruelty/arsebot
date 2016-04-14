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

  def self.normalize(name)
    name.gsub(/\s+/, "").downcase
  end

  match /^lcs ?(?<seq1>\w*)? ?(?<seq2>\w*)?$/ do |client, data, match|
    seq1, seq2 = match[:seq1], match[:seq2]
    if !seq1.empty? && !seq2.empty?
      # today lookup usernames of cur user, all other users, use those
      seq = lcs(seq1, seq2)
      response = "Longest common subsequence for #{seq1} and #{seq2}:\n"
      response += "#{seq} (#{seq.size})"
    else
      user_id = data.user
      user = client.users[user_id]
      real_name = user.profile['real_name']
      sender = [user.name, real_name]
      others = client.users.map do |user_id, user|
        [user.name, user.profile['real_name']] unless user.is_bot
      end
      others.compact!
      response = "Longest common subsequence shared by #{real_name} and\n\n:"
      others.each do |other|
        other_name = other.last
        seq = lcs(normalize(real_name), normalize(other_name))
        response += "#{other_name} - #{seq} (#{seq.size})\n"
      end
    end
    client.say(text: "#{response}", channel: data.channel)
  end

end

ArseBot.run