class Report < ActiveRecord::Base
  ALPHABET = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ"
  BASE = ALPHABET.length

  def data
    JSON.parse report
  end

  def short_id
    int_val = self.id

    base58_val = ''
    while int_val >= BASE
      mod = int_val % BASE
      base58_val = ALPHABET[mod,1] + base58_val
      int_val = (int_val - mod)/BASE
    end

    ALPHABET[int_val,1] + base58_val
  end

  def self.find_from_short_id(base58_val)
    int_val = 0
    base58_val.reverse.split(//).each_with_index do |char,index|
      raise ArgumentError, 'Value passed not a valid Base58 String.' if (char_index = ALPHABET.index(char)).nil?
      int_val += (char_index)*(BASE**(index))
    end

    Report.find int_val
  end
end
