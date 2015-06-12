require 'hipchat'

# require 'net/http'
# require 'uri'

# url = "https://api.hipchat.com/v1/rooms/list?auth_token=#{API_TOKEN}"
# puts Net::HTTP.get(URI.parse(url))

require 'json'

# client[ROOM].send('cbrwizard', 'I talk')
# client[ROOM].get_room

class PerfectusBot
  ROOM = 'sandbox'

  EXERCISES = ['PUSHUPS', 'SECOND PLANK', 'SITUPS', 'SECOND WALL SIT']
  EXERCISES_ANNOUNCEMENTS = ['PUSHUPS', 'PLANK', 'SITUPS', 'WALL SIT']

  class << self
    def client
      @client ||= HipChat::Client.new(ENV['API_TOKEN'], api_version: 'v2')
    end

    def init
      i = 0
      while i < 5 do
        p ENV['API_TOKEN']
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
      # hipchat_users = client[ROOM].get_room
      users_raw = JSON.parse(
                    '
{
  "users":[
    {
      "user_id":1,
      "name":"Chris Rivers",
      "mention_name":"chris",
      "email":"chris@hipchat.com",
      "title":"Developer",
      "photo_url":"https:\/\/www.hipchat.com\/chris.png",
      "last_active":1360031425,
      "created":1315711352,
      "status":"away",
      "status_message":"gym, bbl",
      "is_group_admin":1,
      "is_deleted":0
    },
    {
      "user_id":3,
      "name":"Peter Curley",
      "mention_name":"pete",
      "email":"pete@hipchat.com",
      "title":"Designer",
      "photo_url":"https:\/\/www.hipchat.com\/pete.png",
      "last_active":1360031425,
      "created":1315711352,
      "status":"offline",
      "status_message":"",
      "is_group_admin":1,
      "is_deleted":0
    },
    {
      "user_id":5,
      "name":"Garret Heaton",
      "mention_name":"garret",
      "email":"garret@hipchat.com",
      "title":"Co-founder",
      "photo_url":"https:\/\/www.hipchat.com\/garret.png",
      "last_active":1360031425,
      "created":1315711352,
      "status":"available"
    }
  ]
}'
      )
      users_raw['users'].map { |user| user['mention_name'] }
    end

    def choose_user(users = get_users)
      chosen_user_index = rand(users.length)
      users[chosen_user_index] #todo: get correctly from hipchat here
    end

    def announce_next_exercise(time_until_next_lottery)
      @current_exercise = false # reset it so it gets new data

      # next_lottery_string = "NEXT LOTTERY FOR #{current_exercise[:name]} IS IN #{time_until_next_lottery/60} MINUTES"
      next_lottery_string = "NEXT LOTTERY FOR #{current_exercise[:announcement]} IS IN #{time_until_next_lottery} SECONDS"
      # send message with string
      # client[ROOM].send(ROOM, next_lottery_string)
      p next_lottery_string
    end

    def announce_exercise
      lottery_winner_string = "#{current_exercise[:reps]} #{current_exercise[:name]} RIGHT NOW @#{choose_user}"
      # send message with string
      p lottery_winner_string
      # client[ROOM].send(ROOM, lottery_winner)
    end
  end
end

def get_env
  # assumes the following format
  #  NAME1 = value1
  #  NAME2 = value2
  File.open(File.dirname(__FILE__) + '/secrets.txt').each do |line|
    key, value = line.split " = "
    ENV[key] = value
  end
end

get_env

PerfectusBot.init