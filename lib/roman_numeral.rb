require File.dirname(__FILE__) + '/roman_numeral_error'

class RomanNumeral

  ################
  # Constants
  ################
  MAXIMUM_VALUE = 4999
  MINIMUM_VALUE = 0

  NUMBERS = {
    "I" => {
      "value" => 1
    },
    "V" => {
      "value" => 5
    },
    "X" => {
      "value" => 10
    },
    "L" => {
      "value" => 50
    },
    "C" => {
      "value" => 100
    },
    "D" => {
      "value" => 500
    },
    "M" => {
      "value" => 1000
    }
  }

  INVALID_SEQUENCES = [
    "IIII", "XXXX", "CCCC", "MMMM", 'DD', "LL", "VV", "IL",
    "IC", "ID", "IM", "XD", "XM", "VL", "VX", "VC", "VM", "VD",
    "LC", "LD", "LM", "DM"
  ]

  #################
  # Accessors
  #################
  attr_accessor :number

  #################
  # Initialize
  #################
  def initialize(number)
    self.number = number
    raise_unless_valid
  end

  #################
  # Public Methods
  #################
  def value
    sum = 0
    number_arr = number.split("").reverse

    number_arr.each_with_index do |roman_literal, index|
      literal_value = NUMBERS[roman_literal]["value"]
      if index == 0 || literal_value >=  NUMBERS[number_arr[index - 1]]["value"]
        sum += literal_value
      else
        sum -= literal_value
      end
    end

    return sum if sum_is_in_max_min_range? sum
    raise_exception
  end

  ################
  # Private
  ################
  private

  def sum_is_in_max_min_range?(sum)
    (MINIMUM_VALUE..MAXIMUM_VALUE).cover? sum
  end

  def raise_unless_valid
    INVALID_SEQUENCES.each do |invalid_sequence|
      raise_exception if number.match /#{invalid_sequence}/
    end
  end

  def raise_exception
    raise RomanNumeralError, "Invalid roman number"
  end

end
