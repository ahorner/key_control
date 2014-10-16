require "test_helper"

describe KeyControl::KeyRing do
  let(:secret) { "the secret time forgot" }
  let(:key) { "my-key" }

  before do
    ring[key].must_equal nil
  end

  after do
    begin
      ring.delete(key)
    rescue SystemCallError
      # Ignore keys which aren't set
    end
  end

  describe "thread keyring" do
    let(:ring) do
      KeyControl::KeyRing.new(KeyControl::THREAD)
    end

    it "allows read/write for values in the same thread" do
      ring[key] = secret
      ring[key].must_equal secret
    end

    it "uses a new keyring for new threads" do
      Thread.new { ring[key] = secret }.join

      ring[key].must_equal nil
    end

    it "raises an exception when deleting a key which has not been set" do
      -> { ring.delete key }.must_raise Errno::ENOKEY
    end

    it "allows an expiration timeout to be set on a key" do
      timeout = 1
      ring[key] = secret
      ring.set_timeout(key, timeout)

      ring[key].must_equal secret
      sleep timeout + 0.1
      ring[key].must_equal nil
    end
  end

  describe "process keyring" do
    let(:ring) do
      KeyControl::KeyRing.new(KeyControl::PROCESS)
    end

    it "allows read/write of values in the same process" do
      ring[key] = secret
      ring[key].must_equal secret
    end

    it "allows read/write of values across threads in the same process" do
      Thread.new { ring[key] = secret }.join

      ring[key].must_equal secret
    end

    it "uses a new keyring for new processes" do
      pid = fork { ring[key] = secret and exit }
      Process.waitpid(pid)

      ring[key].must_equal nil
    end
  end

  describe "session keyring" do
    let(:ring) do
      KeyControl::KeyRing.new(KeyControl::SESSION)
    end

    it "allows read/write of values in the same thread/process" do
      ring[key] = secret
      ring[key].must_equal secret
      ring.delete key
    end

    it "allows read/write of values across threads in the same process" do
      Thread.new { ring[key] = secret }.join

      ring[key].must_equal secret
      ring.delete key
    end

    it "allows read/write of values across processes in the same session" do
      pid = fork { ring[key] = secret and exit }
      Process.waitpid(pid)

      ring[key].must_equal secret
      ring.delete key
    end
  end
end
