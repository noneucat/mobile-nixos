module HAL
  class Battery
    NODE_BASE = "/sys/class/power_supply"
    # Guesstimates the main battery for a list of likely candidates
    def self.main_battery()
      node = %w{
        battery
        bms
        BAT0
      }.map { |name| File.join(NODE_BASE, name) }
        .find { |path| File.exist?(path) }

      if node
        Battery.new(node)
      else
        nil
      end
    end

    def initialize(node)
      @node = node
    end

    # google-walleye
    # [nixos@nixos:/sys/class/power_supply]$ cat battery/uevent 
    # POWER_SUPPLY_NAME=battery
    # POWER_SUPPLY_INPUT_SUSPEND=0
    # POWER_SUPPLY_STATUS=Charging
    # POWER_SUPPLY_HEALTH=Good
    # POWER_SUPPLY_PRESENT=1
    # POWER_SUPPLY_CHARGE_TYPE=Fast
    # POWER_SUPPLY_CAPACITY=56
    # POWER_SUPPLY_SYSTEM_TEMP_LEVEL=0
    # POWER_SUPPLY_CHARGER_TEMP=364
    # POWER_SUPPLY_CHARGER_TEMP_MAX=803
    # POWER_SUPPLY_INPUT_CURRENT_LIMITED=1
    # POWER_SUPPLY_VOLTAGE_NOW=3780507
    # POWER_SUPPLY_VOLTAGE_MAX=4400000
    # POWER_SUPPLY_VOLTAGE_QNOVO=-22
    # POWER_SUPPLY_CURRENT_NOW=183105
    # POWER_SUPPLY_CURRENT_QNOVO=-22
    # POWER_SUPPLY_CONSTANT_CHARGE_CURRENT_MAX=2700000
    # POWER_SUPPLY_TEMP=320
    # POWER_SUPPLY_TECHNOLOGY=Li-ion
    # POWER_SUPPLY_STEP_CHARGING_ENABLED=0
    # POWER_SUPPLY_STEP_CHARGING_STEP=-1
    # POWER_SUPPLY_CHARGE_DISABLE=0
    # POWER_SUPPLY_CHARGE_DONE=0
    # POWER_SUPPLY_PARALLEL_DISABLE=0
    # POWER_SUPPLY_SET_SHIP_MODE=0
    # POWER_SUPPLY_CHARGE_FULL=2805000
    # POWER_SUPPLY_DIE_HEALTH=Cool
    # POWER_SUPPLY_RERUN_AICL=0
    # POWER_SUPPLY_DP_DM=0
    # POWER_SUPPLY_CHARGE_COUNTER=1455951
    # POWER_SUPPLY_CYCLE_COUNT=849
    def uevent()
      File.read(File.join(@node, "uevent")).split("\n").map do |line|
        key, value = line.split("=", 2)
        [key.downcase.to_sym, value]
      end.to_h
    end

    def name()
      uevent[:power_supply_name] || "unknown"
    end

    def status()
      uevent[:power_supply_status] || "unknown"
    end

    def percent()
      uevent[:power_supply_capacity] || "unknown"
    end
  end
end
