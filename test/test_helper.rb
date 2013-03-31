# encoding: utf-8
ENV['TTT_ENV'] = 'test'

require "rubygems"
# require 'minitest/spec'
require "minitest/autorun"
require "stringio"
require_relative "../lib/ttt"


# To test IO
# from http://technicalpickles.com/posts/a-pattern-for-using-standard-in-and-out-in-your-ruby-code/
def withIO(newin, newout)
  old_STDIN = $stdin
  old_STDOUT = $stdout
  $stdin = newin
  $stdout = newout
  yield old_STDIN, old_STDOUT
  ensure
  $stdin = old_STDIN
  $stdout = old_STDOUT
end