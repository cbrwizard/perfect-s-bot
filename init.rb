require 'hipchat'

class PerfectusBot
  EXERCISES = ['PUSHUPS', 'SECOND PLANK', 'SITUPS', 'SECOND WALL SIT']
  EXERCISES_ANNOUNCEMENTS = ['PUSHUPS', 'PLANK', 'SITUPS', 'WALL SIT']

  class << self
    def client
      @client ||= HipChat::Client.new(ENV['API_TOKEN'], api_version: 'v2')
    end
    
    def room
      @room ||= ENV['ROOM']
    end

    def init
      i = 0
      while i < 5 do
        announce_exercise
        time_until_next_lottery = rand(3..5) # 300..1800
        announce_next_exercise(time_until_next_lottery)
        i +=1
        sleep(time_until_next_lottery)
      end
    end

    def current_exercise
      @current_exercise ||= choose_exercise
    end

    def choose_exercise
      chosen_exercise_index = rand(EXERCISES.length)
      chosen_exercise_name = EXERCISES[chosen_exercise_index]
      chosen_exercise_announcement = EXERCISES_ANNOUNCEMENTS[chosen_exercise_index]
      exercise_reps = rand(25..50)

      {
        name: chosen_exercise_name,
        announcement: chosen_exercise_announcement,
        reps: exercise_reps
      }
    end

    def get_users
      client[room].get_room['participants'].map { |user| user['mention_name'] }
    end

    def choose_user(users = get_users)
      chosen_user_index = rand(users.length)

      users[chosen_user_index] #todo: get correctly from hipchat here
    end

    def announce_next_exercise(time_until_next_lottery)
      @current_exercise = false # reset it so it gets new data

      # next_lottery_string = "NEXT LOTTERY FOR #{current_exercise[:name]} IS IN #{time_until_next_lottery/60} MINUTES"
      next_lottery_string = "NEXT LOTTERY FOR #{current_exercise[:announcement]} IS IN #{time_until_next_lottery} SECONDS"

      client[room].send(room, next_lottery_string)
    end

    def announce_exercise
      lottery_winner_string = "#{current_exercise[:reps]} #{current_exercise[:name]} RIGHT NOW @#{choose_user}"

      client[room].send(room, lottery_winner_string)
    end
  end
end

def get_env
  # assumes the following format
  #  NAME1 = value1
  #  NAME2 = value2
  File.open(File.dirname(__FILE__) + '/settings.txt').each do |line|
    key, value = line.chomp.split " = "
    ENV[key] = value
  end
end

get_env

PerfectusBot.init