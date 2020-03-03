require "test_helper"

class StranglerTest < Minitest::Test

  REPEATS = 10
  CALLS = 10
  THREADS = 3
  MINIMUM_DELAY_SECS = 0.1
  EXCEPTION_LOOPS = [2,3,8]   # Throw exception inside block these loops

  SETUP = begin
    puts "Expected Longest Test Duration: ~#{REPEATS * CALLS * THREADS * MINIMUM_DELAY_SECS} secs"
  end


  def test_that_it_has_a_version_number
    refute_nil ::Strangler::VERSION
  end

  # We try and replicate a multi-threaded set of calls
  def test_throttling


    # To check for any race conditions, we repeat the test a few times...
    REPEATS.times do

      strangler = Strangler.new( MINIMUM_DELAY_SECS )

      threads = []
      times = []    # Array of [Start, finish, thread number] for each job processed
      times_lock = Mutex.new
      exceptions = 0
      exceptions_lock = Mutex.new



      # Execute THREADS*CALLS calls in muliple threads
      # Note that the start and finish times must be determined inside the throttle! call
      (1..THREADS).each do |iThread|
        threads << Thread.new {
          (1..CALLS).each do |i|
            start = 0 # Establish scope
            finish = 0
            begin
              strangler.throttle! do
                start = Time.now
                if EXCEPTION_LOOPS.include? i
                  finish = Time.now
                  raise IOError, "Something went wrong!" 
                else
                  sleep [ 0, MINIMUM_DELAY_SECS*0.1, MINIMUM_DELAY_SECS*0.9, MINIMUM_DELAY_SECS*1.1].sample
                  finish = Time.now
                end
              end
            rescue IOError
              # We thought this might happen...   
              exceptions_lock.synchronize { exceptions += 1 }    
            ensure
                times_lock.synchronize { times << [start,finish,iThread] }
            end
          end
        }
      end

      threads.each { |thread| thread.join }

      assert_equal THREADS*CALLS, times.length, "tmes array not being updated correctly"
      assert_equal THREADS*EXCEPTION_LOOPS.length, exceptions, "Exception count not being updated correctly"

      # Check that all the executions were separated by MINIMUM_DELAY_SECS 
      (1..times.length-1).each do |i|
        start,finish,thread = times[i]
        if false
          puts "#{start.strftime('%H:%M:%S.%N')} - #{finish.strftime('%H:%M:%S.%N')} worked on thread #{thread}"
        end
        unless i==0
          _, last_finish, _ = times[i-1]
          delay = (start - last_finish)
          assert delay >= MINIMUM_DELAY_SECS, "Delay between finish #{_pt(last_finish)} and start #{_pt(start)} was less than #{MINIMUM_DELAY_SECS}"
        end
      end

    end
  end


  def _pt( time )
    time.strftime("%H:%M:%S.%N")
  end
end
