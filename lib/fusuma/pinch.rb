module Fusuma
  # vector data
  class Pinch
    TYPE = 'pinch'.freeze

    BASE_THERESHOLD = 0.3
    BASE_INTERVAL   = 0.05

    def initialize(finger, diameter = 0)
      @finger = finger.to_i
      @diameter = diameter.to_f
    end

    attr_reader :finger, :diameter

    def direction
      return 'in' if diameter > 0

      'out'
    end

    def enough?
      MultiLogger.debug(diameter: diameter)
      enough_diameter? && enough_interval?
    end

    private

    def enough_diameter?
      diameter.abs > threshold
    end

    def enough_interval?
      return true if first_time?
      return true if (Time.now - self.class.last_time) > interval_time

      false
    end

    def first_time?
      !self.class.last_time
    end

    def threshold
      @threshold ||= BASE_THERESHOLD * Config.threshold(self)
    end

    def interval_time
      @interval_time ||= BASE_INTERVAL * Config.interval(self)
    end

    class << self
      attr_reader :last_time

      def touch_last_time
        @last_time = Time.now
      end
    end
  end
end
