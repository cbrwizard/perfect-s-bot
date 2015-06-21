require 'hipbot'
require_relative 'sporty_brains'

class PerfectSBot < Hipbot::Bot
  class << self
    def brains
      @brains ||= SportyBrains
    end

    def bot_mention
      @bot_mention ||= self.name
    end

    def add_brains_to_bot(response)
      brains.init(response: response, bot: self)
    end

    def users_mentions
      online_users.map { |user| user.attributes[:mention] } if online_users
    end

    def online_users
      Hipbot::User
        .all
        .select { |user| user.attributes[:mention] != bot_mention && user.attributes[:is_online] }
    end

    def anybody_online?
      online_users.length > 0
    end
  end

  on /^start$/ do
    reply 'Resistance is futile: your butt will be in shape!'
    PerfectSBot.add_brains_to_bot(self)
  end
end
