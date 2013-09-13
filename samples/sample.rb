#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'babascript'

BabaScript.baba :base => "http://localhost:5000", :space => "test" do
  if Time.now.hour < 12
    puts そろそろ起きたほうがいいのでは？
  else
    puts アイス買ってきてよ("#{rand(10)}本")
  end
end
