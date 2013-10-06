# -*- coding: utf-8 -*-
require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestBabaScript < MiniTest::Test

  def test_eval_write_tuple
    base = ENV["LINDA_BASE"] || BabaScript::DEFAULTS[:base]
    space = ENV["LINDA_SPACE"] || BabaScript::DEFAULTS[:space]
    tuple_ = nil
    res_ = nil
    EM::run do
      linda = EM::RocketIO::Linda::Client.new base
      ts = linda.tuplespace[ space ]
      linda.io.once :connect do
        ts.take [:babascript, :eval] do |tuple, info|
          tuple_ = tuple
          ts.write [:babascript, :return, tuple[4]["callback"], "ざんまい"]
          EM::add_timer 1 do
            EM::stop
          end
        end
      end

      BabaScript.baba :base => base, :space => space do
        res_ = テスト 1, 2, "かずすけ"
      end
    end

    assert_equal tuple_.class, Array
    assert_equal tuple_.size, 5
    assert_equal tuple_[0], "babascript"
    assert_equal tuple_[1], "eval"
    assert_equal tuple_[2], "テスト"
    assert_equal tuple_[3], [1, 2, "かずすけ"]
    assert_equal tuple_[4].class, Hash
    assert tuple_[4].has_key? "callback"

    assert_equal res_, "ざんまい"
  end

end
