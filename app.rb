require_relative 'bot'
require_relative 'settings_loader'

SettingsLoader.load

PerfectSBot.configure do |c|
  c.jid = ENV['jid']
  c.password = ENV['password']
  c.status = ENV['status']
  c.join = ENV['room']
end

PerfectSBot.start!
