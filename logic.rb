require 'sinatra'
require 'sqlite3'

module Reddish
  def Reddish.database
    SQLite3::Database.new 'reddish.sqlite'
  end
  
  def Reddish.username_by_id(user_id)
    db = Reddish.database
    users = db.execute('SELECT username FROM users WHERE id = ? LIMIT 1', [user_id])
    if users.size > 0
      return users[0][0]
    end
  end
  
  def Reddish.create_link(id, title, description, url, category_id, user_id,
                          category_name, username, created_at, ago)
    {
      "id" => id,
      "title" => title,
      "description" => description,
      "url" => url,
      "category_id" => category_id,
      "user_id" => user_id,
      "category_name" => category_name,
      "username" => username,
      "created_at" => created_at,
      "ago" => ago,
    }
  end
  
  def Reddish.ago(created_at)
    secs_in_min = 60
    secs_in_hour = secs_in_min * 60
    secs_in_day = secs_in_hour * 24
    secs_in_week = secs_in_day * 7
    secs_in_year = secs_in_week * 365.25
    
    ago_in_mins = (Time.now.to_i - created_at) / secs_in_min
    answer = "#{ago_in_mins} minutes ago"
    if ago_in_mins > 59
      ago_in_hours = (Time.now.to_i - created_at) / secs_in_hour
      answer = "#{ago_in_hours} hours ago"
      if ago_in_hours > 23
        ago_in_days = (Time.now.to_i - created_at) / secs_in_day
        answer = "#{ago_in_days} days ago"
        if ago_in_days > 6
          ago_in_weeks = (Time.now.to_i - created_at) / secs_in_week
          answer = "#{ago_in_weeks} weeks ago"
          if ago_in_weeks > 51
            ago_in_years = (Time.now.to_i - created_at) / secs_in_year
            answer = "#{ago_in_years} years ago"
          end
        end
      end
    elsif ago_in_mins < 5
      answer = "just now"
    end
    return answer
  end
end