module Faker
  class BankAccount < Base
    class << self
      def iban
        iban_format = translate('faker.bank_account.iban_format')
        raise NotImplementedError("Locale #{locale} not yet supported for IBAN generation") unless iban_format
        iban = regexify(iban_format)
        calc = iban.gsub(/_/, '0')
        calc = calc[(4..-1)] + calc[0,4]
        calc = calc.upcase.gsub(/[A-Z]/i) { |s| s.ord-55 }
        checksum = 98 - (calc.to_i % 97)
        iban.gsub(/_+/, sprintf('%02d', checksum))
      end
    end
  end
end