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

    def get_users
      Hipbot::User.all.select { |user| user.mention != bot_mention }.map(&:mention)
    end
  end

  on /^start$/ do
    reply 'Resistance is futile: your butt will be in shape!'
    PerfectSBot.add_brains_to_bot(self)
  end
end
