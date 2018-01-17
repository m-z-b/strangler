require "test_helper"

class StranglerTest < Minitest::Test

  CALLS = 5
  THREADS = 3
  MINIMUM_DELAY_SECS = 0.5

  SETUP = begin
    puts "Expected Longest Test Duration: ~#{CALLS * THREADS * MINIMUM_DELAY_SECS} secs"
  end


  def test_that_it_has_a_version_number
    refute_nil ::Strangler::VERSION
  end

  # We try and replicate a multi-threaded set of calls
  def test_throttling

    strangler = Strangler.new( MINIMUM_DELAY_SECS )

    threads = []
    times = []    # Array of [Start, finish, thread number] for each job processed

    # Execute THREADS*CALLS calls in muliple threads
    (1..THREADS).each do |iThread|
      threads << Thread.new {
        (1..CALLS).each do |i|
          strangler.throttle! do
            start = Time.now
            sleep [ 0, 0.1, 0.3, 1.1].sample
            finish = Time.now
            times << [start,finish,iThread]
          end
        end
      }
    end

    threads.each { |thread| thread.join }

    assert_equal THREADS*CALLS, times.length

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


    nil 
  end


  def _pt( time )
    time.strftime("%H:%M:%S.%N")
  end
end
