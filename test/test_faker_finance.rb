require File.dirname(__FILE__) + '/test_helper.rb'

class TestFakerFinance < Test::Unit::TestCase
  def setup
    @tester = Faker::Finance
  end

  def test_iban
    # no IBAN in the US, set to UK
    I18n.with_locale 'en-GB' do
      iban = @tester.iban
      assert iban.match(/^[a-z]{2}\d{2}\w{11,30}$/i)
      # @see https://en.wikipedia.org/wiki/International_Bank_Account_Number#Validating_the_IBAN
      iban = iban[(4..-1)] + iban[0,4]
      iban = iban.upcase.gsub(/[A-Z]/i) { |s| s.ord-55 }
      assert iban.to_i % 97 == 1
    end
  end

  def test_iban_de
    I18n.with_locale :de do
      iban = @tester.iban
      assert iban.match(/^DE\d{20}$/i)
    end
  end

  def test_iban_at
    I18n.with_locale 'de-AT' do
      iban = @tester.iban
      assert iban.match(/^AT\d{18}$/i)
    end
  end

  def test_iban_ch
    I18n.with_locale 'de-CH' do
      iban = @tester.iban
      assert iban.match(/^CH\d{7}\w{12}$/i)
    end
  end

  def test_iban_nl
    I18n.with_locale :nl do
      iban = @tester.iban
      assert iban.match(/^NL\d{2}[A-Z]{4}\d{10}$/i)
    end
  end

  def test_bic
    bic = @tester.bic
    assert bic.match(/^[A-Z]{6}\w{2}(\w{3})?$/i)
  end

end