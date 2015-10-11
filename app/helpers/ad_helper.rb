# encoding : utf-8
module AdHelper

  def self.get_users_ranking(limit=20, last_week=false)
    if last_week
      User.last_week.order("ads_count DESC").select('username, ads_count, id').limit(limit)
    else
      User.order("ads_count DESC").select('username, ads_count, id').limit(limit)
    end
  end

  def self.get_locations_ranking(limit=20)
    Ad.give.group_by(&:woeid_code).map{ |w,a| [WoeidHelper.convert_woeid_name(w)[:full], w, a.count] }.sort_by{|k| k[2]}.reverse.take(limit) 
  end

end
