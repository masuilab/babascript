module BabaScript
  def self.baba(opts={}, &block)
    self::Baba.new(opts).run &block if block_given?
  end

  class Baba

    def initialize(opts)
      @base  = opts[:base]  || "http://linda.masuilab.org"
      @space = opts[:space] || "takumibaba"
    end

    def linda
      @linda ||= EM::RocketIO::Linda::Client.new @base
    end

    def run(code=nil, &block)
      raise ArgumentError "block or code require" unless block_given? or code.kind_of? String
      already_eventmachine_running = EM::reactor_running?
      this = self
      EM::run do
        linda.io.once :connect do
          EM::defer do
            if block_given?
              this.instance_eval &block
            else
              this.instance_eval code
            end
            unless already_eventmachine_running
              EM::add_timer 1 do
                EM::stop
              end
            end
          end
        end
      end
    end

    def method_missing(name, *args, &block)
      cid = __create_callback_id
      tuple = [:babascript, :eval, name, args, {:callback => cid}]
      ts = linda.tuplespace[@space]
      ts.write tuple
      if block_given?
        ts.take [:babascript, :return, cid] do |result|
          next if result.size < 4
          block.call result[3]
        end
      else
        result = ts.take [:babascript, :return, cid]
        return result[3]
      end
    end

    private
    def __create_callback_id
      Digest::MD5.hexdigest "#{Time.now.to_i}_#{Time.now.usec}_#{rand 100000}"
    end
  end
end
