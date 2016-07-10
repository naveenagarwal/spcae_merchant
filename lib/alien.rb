require File.dirname(__FILE__) + '/roman_numeral'

class Alien

  #################
  # Constants
  #################
  INVALID_INPUT = "I have no idea what you are talking about"
  VALID_INPUTS   = {
    :has_only_dirt  => /(glob|prok|pish|tegj) is (I|V|X|L|C|D|M)/,
    :has_metal      => /(glob|prok|pish|tegj) \w+ (Silver|Gold|Iron) is \d+ Credits/,
    :question       => /(much|many Credits) is \w+ ?/
  }

  #################
  # Accessors
  #################
  attr_accessor   :roman_number, :string

  ###################
  # Class variables
  ###################
  @@numeral_hash ||= {}

  ###############
  # Initialize
  ###############
  def initialize(string)
    self.string = string
  end

  #################
  # Public Methods
  #################
  def calculate
    if valid?
      evaluate
    else
      puts INVALID_INPUT
    end
  end

  ##############
  # Private
  ##############
  private

  def valid?
    VALID_INPUTS.each do |key, value|
      if string.match value
        @input_type = key
        return true
      end
    end
    false
  end

  def evaluate
    if @input_type == :question
      calculate_credits
    else
      set_numeral_hash
    end
  end

  def set_numeral_hash
    case @input_type
    when :has_only_dirt
      make_entry_for_dirt
    when :has_metal
      make_entry_for_metal
    end
  end

  def make_entry_for_dirt
    arr           = string.split(" is ").each { |str| str.strip! }
    numeral_hash  = { arr[0] => arr[1] }

    @@numeral_hash.merge! numeral_hash
  end

  def make_entry_for_metal
    base_string = string.match(/^(\w+ )+(Silver|Gold|Iron)/).to_a.first
    metal       = base_string.match(/(Silver|Gold|Iron)/).to_a.first

    base_string.sub! metal, ""

    dirt        = calculate_dirt_roman_numeral_value base_string
    credits     = string.match(/\d+/).to_a.first.to_i

    @@numeral_hash.merge! calulate_metal_value_hash(metal, dirt, credits)
  end

  def calculate_dirt_roman_numeral_value(dirt)
    self.roman_number = dirt.split(" ").map { |material| @@numeral_hash[material] }
      .compact.join ""

    RomanNumeral.new(roman_number).value
  end

  def calulate_metal_value_hash(metal, dirt, credits)
    {
      metal => credits.to_f / dirt.to_f
    }
  end

  def calculate_credits
    base_string = string.sub /how (many|much is) [(Credits is)?]/, ''
    base_string = base_string.match(/^(\w+ )+[(Silver|Gold|Iron)?]/).to_a.first
    metal       = base_string.match(/(Silver|Gold|Iron)/).to_a.first

    base_string.sub! /\s\?/, ""
    base_string.sub! metal, "" if metal

    dirt        = calculate_dirt_roman_numeral_value base_string
    credits     = dirt * (@@numeral_hash[metal] || 1)

    puts credit_statement credits
  end

  def credit_statement(credits)
    base_string  = string.sub(/\s\?/, "")

    if base_string.match /how much is/
      base_string.sub! /how much is /, ""
      text = "#{base_string} is #{credits.to_i}"
    else
      base_string.sub! /how many Credits is /, ""
      text = "#{base_string} is #{credits.to_i} Credits"
    end
    text
  end

end