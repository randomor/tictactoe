# encoding: utf-8
Dir["./lib/ttt/*.rb"].each {|file| require file }; g=TTT::Game.new; g.start