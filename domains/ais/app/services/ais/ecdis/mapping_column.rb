module Ais
  module Ecdis
    class MappingColumn
      FURUNO = {
        :NAME  => 0, :LAT => 1, :LON => 2,:LEG_TYPE => 3, :TURN_RADIUS => 4,
        :CHN_LIMIT => 5, :PLANNED_SPEED => 6, :SPEED_MIN => 7, :SPEED_MAX => 10,
        :COURSE => 11, :LENGTH => 12, :DO_PLAN => 14, :HFO_PLAN => 15,
        :HFO_LEFT => 16, :DO_LEFT => 17, :ETA_DAY => 18, :ETA_TIME => 19
      }

      JRC = {
        :LAT => 1, :LAT_D => 2, :LAT_C => 3,
        :LON => 4, :LON_D => 5, :LON_C => 6, :PORT => 7, :STBD => 8, :ARR_RAD => 9,
        :SPEED => 10, :SAIL => 11, :ROT => 12, :TURN_RAD => 13, :TIME_ZONE => 14, :NAME => 16
      }
    end
  end
end
