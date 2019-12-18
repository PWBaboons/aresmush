module AresMUSH
  module Magic

    #Can read armor or weapon
    def self.is_magic_weapon(gear)
      FS3Combat.weapon_stat(gear, "is_magic")
    end

    def self.is_magic_armor(gear)
      FS3Combat.armor_stat(gear, "is_magic")
    end

    def self.warn_if_magic_armor(armor, combat)
      if Magic.is_magic_armor(armor)
        FS3Combat.emit_to_combat(combat, t('magic.cast_to_use', :name => armor))
      end
    end

    def self.warn_if_magic_weapon(weapon, combat)
      if Magic.is_magic_weapon(weapon)
        FS3Combat.emit_to_combat(combat, t('magic.cast_to_use', :name => weapon))
      end
    end

  end
end
