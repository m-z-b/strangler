require 'thread'

# Limit calls to an API by sleeping
class Strangler
  VERSION = "1.0.3"


  # Set the minimum delay between calls
  def initialize( minimum_delay_secs = 1.1 )
    @minimum_delay_secs = minimum_delay_secs
    @semaphore = Mutex.new
    @next_call = nil      # Earliest time a new block can be executed
  end


  # Ensure that calls do not exceed the rate limit by delaying thread
  # We assume that we must wait at least @minimum_delay_seconds since end of last call
  # Note that the delay is measured from the end of any previous call
  def throttle!
    raise ArgumentError, "Must supply a block to throttle!" unless block_given?
    @semaphore.synchronize do
      unless @next_call.nil?
        while Time.now < @next_call
          doze_time = @next_call - Time.now
          sleep doze_time
        end
      end
      yield # Do the stuff
      @next_call = Time.now + @minimum_delay_secs
    end
  end
end
