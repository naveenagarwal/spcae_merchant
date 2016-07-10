#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/lib/alien.rb'

class Merchant

  ################
  #public methods
  ################
  def parse(input_strings)
    input_strings.each do |string|
      alien = Alien.new string
      alien.calculate
    end
  end

end

input_strings = [
  "glob is I",
  "prok is V",
  "pish is X",
  "tegj is L",
  "glob glob Silver is 34 Credits",
  "glob prok Gold is 57800 Credits",
  "pish pish Iron is 3910 Credits",
  "how much is pish tegj glob glob ?",
  "how many Credits is glob prok Silver ?",
  "how many Credits is glob prok Gold ?",
  "how many Credits is glob prok Iron ?",
  "how much wood could a woodchuck chuck if a woodchuck could chuck wood ?"
]

Merchant.new.parse(input_strings)