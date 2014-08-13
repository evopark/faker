module Faker
  class Finance < Base
    CREDIT_CARD_TYPES = [ :visa, :mastercard,  :discover, :american_express, :diners_club, :jcb, :switch, :solo, :dankort, :maestro, :forbrugsforeningen, :laser ]

    class << self
      def credit_card(*types)
        types = CREDIT_CARD_TYPES if types.empty?
        type = types.sample
        template = numerify(fetch("credit_card.#{type}"))

        # calculate the luhn checksum digit
        multiplier = 1
        luhn_sum = template.gsub(/[^0-9]/, '').split('').reverse.map(&:to_i).inject(0) do |sum, digit|
          multiplier = (multiplier == 2 ? 1 : 2)
          sum + (digit * multiplier).to_s.split('').map(&:to_i).inject(0) { |digit_sum, cur| digit_sum + cur }
        end
        # the sum plus whatever the last digit is must be a multiple of 10. So, the
        # last digit must be 10 - the last digit of the sum.
        luhn_digit = (10 - (luhn_sum % 10)) % 10

        template.gsub! 'L', luhn_digit.to_s
        template
      end

      # generates an International Bank Account Number
      # https://en.wikipedia.org/wiki/International_Bank_Account_Number
      def iban
        iban_format = translate('faker.bank_account.iban_format')
        raise NotImplementedError("Locale #{locale} not yet supported for IBAN generation") unless iban_format
        iban = regexify(iban_format)
        calc = iban.gsub(/_/, '0') # Initialize checksum to 0
        calc = calc[(4..-1)] + calc[0,4] # move first 4 chars to end
        calc = calc.upcase.gsub(/[A-Z]/i) { |s| s.ord-55 } # replace letters by numbers
        checksum = 98 - (calc.to_i % 97)
        iban.gsub(/_+/, sprintf('%02d', checksum))
      end

      # generates a bank identifier code
      # https://en.wikipedia.org/wiki/ISO_9362
      def bic
        regexify('[A-Z]{4}__\w{2}(\w{3})?').upcase.gsub(/__/, fetch('address.country_code'))
      end

    end
  end
end
