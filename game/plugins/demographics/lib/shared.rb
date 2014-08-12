module AresMUSH
  module Demographics
    def self.check_age(age)
      min_age = Global.config['demographics']['min_age']
      max_age = Global.config['demographics']['max_age']
      if (age > max_age || age < min_age)
        return t('demographics.age_outside_limits', :min => min_age, :max => max_age) 
      end
      return nil
    end
    
    def self.calculate_age(dob)
      now = ICTime.ictime
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    end
  end
end