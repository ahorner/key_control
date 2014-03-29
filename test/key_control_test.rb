require "test_helper"

describe KeyControl do
  describe ".available?" do
    it "returns false if the keyctl library can not be found" do
      KeyControl.stub(:library_names, %w[badlib]) do
        KeyControl.available?.must_equal false
      end
    end

    it "returns true if the keyctl library is available" do
      KeyControl.available?.must_equal true
    end
  end
end

describe KeyControl::KeyRing do
  describe "thread keyring" do
    let(:ring) do
      ring = KeyControl::KeyRing.new(KeyControl::THREAD)
    end

    it "allows read/write for values in the same thread" do
      ring["testing"] = "testdata"
      ring["testing"].must_equal "testdata"
    end

    it "uses a new keyring for new threads" do
      ring["thread_test"].must_equal nil
      thr = Thread.new do
        ring["thread_test"] = "testdata"
      end
      thr.join

      ring["thread_test"].must_equal nil
    end
  end

  describe "process keyring" do
    let(:ring) do
      ring = KeyControl::KeyRing.new(KeyControl::PROCESS)
    end

    it "allows read/write of values in the same process" do
      ring["process-test-1"] = "foobar"
      ring["process-test-1"].must_equal "foobar"
    end

    it "allows read/write of values across threads in the same process" do
      ring["process-thread-test"].must_equal nil

      thr = Thread.new do
        ring["process-thread-test"] = "baz"
      end
      thr.join

      ring["process-thread-test"].must_equal "baz"
    end

    it "uses a new keyring for new processes" do
      ring["child-process-test"].must_equal nil

      pid = fork do
        ring["child-process-test"] = "too many secrets"
        exit
      end

      Process.waitpid(pid)
      ring["child-process-test"].must_equal nil
    end
  end

  describe "session keyring" do
    let(:ring) do
      ring = KeyControl::KeyRing.new(KeyControl::SESSION)
    end

    it "allows read/write of values in the same process" do
      ring["session-test-1"] = "foobar"
      ring["session-test-1"].must_equal "foobar"
    end

    it "allows read/write of values across threads in the same process" do
      ring["session-thread-test"].must_equal nil
      thr = Thread.new do
        ring["session-thread-test"] = "baz"
      end
      thr.join

      ring["session-thread-test"].must_equal "baz"
    end

    it "allows read/write of values across processes in the same session" do
      ring["session-process-test"].must_equal nil

      pid = fork do
        ring["session-process-test"] = "too many secrets"
        exit
      end

      Process.waitpid(pid)

      ring["session-process-test"].must_equal "too many secrets"
    end
  end
end
