module AresMUSH
  module Magic

    def self.check_magic_rating(char)
      magic = FS3Skills.ability_rating(char, "Magic")
      max_magic = Global.read_config("magic", "max_cg_magic_rating")
      if magic > max_magic
        msg = t('magic.magic_attribute_too_high', :max => max_magic)
      else
        msg = t('chargen.ok')
      end
      return Chargen.format_review_status "Checking Magic.", msg
    end

  end
end
