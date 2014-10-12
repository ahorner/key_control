require "test_helper"

describe KeyControl::KeyRing do
  let(:secret) { "the secret time forgot" }

  describe "thread keyring" do
    let(:ring) do
      KeyControl::KeyRing.new(KeyControl::THREAD)
    end

    it "allows read/write for values in the same thread" do
      key = "single-thread-test"
      ring[key].must_equal nil

      ring[key] = secret
      ring[key].must_equal secret
      ring.delete key
    end

    it "uses a new keyring for new threads" do
      key = "multi-thread-test"
      ring[key].must_equal nil

      Thread.new { ring[key] = secret }.join

      ring[key].must_equal nil
    end
  end

  describe "process keyring" do
    let(:ring) do
      KeyControl::KeyRing.new(KeyControl::PROCESS)
    end

    it "allows read/write of values in the same process" do
      key = "single-process-test"
      ring[key].must_equal nil

      ring[key] = secret
      ring[key].must_equal secret
      ring.delete key
    end

    it "allows read/write of values across threads in the same process" do
      key = "process-thread-test"
      ring[key].must_equal nil

      Thread.new { ring[key] = secret }.join

      ring[key].must_equal secret
    end

    it "uses a new keyring for new processes" do
      key = "multi-process-test"
      ring[key].must_equal nil

      pid = fork { ring[key] = secret and exit }
      Process.waitpid(pid)

      ring[key].must_equal nil
    end
  end

  describe "session keyring" do
    let(:ring) do
      KeyControl::KeyRing.new(KeyControl::SESSION)
    end

    after do
      session_keys =
        [ "session-test",
          "session-thread-test",
          "session-process-test" ]

      session_keys.each do |k|
        begin
          ring.delete k
        rescue
        end
      end
    end

    it "allows read/write of values in the same thread/process" do
      key = "session-test"
      ring[key].must_equal nil

      ring[key] = secret
      ring[key].must_equal secret
    end

    it "allows read/write of values across threads in the same process" do
      key = "session-thread-test"
      ring[key].must_equal nil

      Thread.new { ring[key] = secret }.join

      ring[key].must_equal secret
    end

    it "allows read/write of values across processes in the same session" do
      key = "session-process-test"
      ring[key].must_equal nil

      pid = fork { ring[key] = secret and exit }
      Process.waitpid(pid)

      ring[key].must_equal secret
    end

    it "raises an exception when key does not exist" do
      -> { ring.delete "a_key_which_does_not_exist" }.must_raise Errno::ENOKEY
    end
  end
end
