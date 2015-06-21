class SportyBrains
  EXERCISES = ['PUSHUPS', 'SECOND PLANK', 'SITUPS', 'SECOND WALL SIT']
  EXERCISES_ANNOUNCEMENTS = ['PUSHUPS', 'PLANK', 'SITUPS', 'WALL SIT']
  NUMBER_OF_REPEATS = 5

  class << self
    attr_accessor :bot, :response

    def current_exercise
      @current_exercise ||= choose_exercise
    end

    def init(response: response, bot: bot)
      self.bot = bot
      self.response = response
      counter = 0

      while counter < NUMBER_OF_REPEATS do
        announce_exercise
        time_until_next_lottery = rand(13..15) # 300..1800
        announce_next_exercise(time_until_next_lottery)
        counter +=1
        sleep(time_until_next_lottery)
      end
    end

    private

    def announce_exercise
      lottery_winner_string = "#{current_exercise[:reps]} #{current_exercise[:name]} RIGHT NOW @#{choose_user}"

      response.reply lottery_winner_string
    end

    def announce_next_exercise(time_until_next_lottery)
      reset_current_exercise

      # next_lottery_string = "NEXT LOTTERY FOR #{current_exercise[:name]} IS IN #{time_until_next_lottery/60} MINUTES"
      next_lottery_string = "NEXT LOTTERY FOR #{current_exercise[:announcement]} IS IN #{time_until_next_lottery} SECONDS"

      response.reply next_lottery_string
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

    def all_users
      bot.all_users
    end

    def choose_user
      chosen_user_index = rand(all_users.length)

      all_users[chosen_user_index]
    end

    def reset_current_exercise
      @current_exercise = false
    end
  end
end
