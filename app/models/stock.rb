class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
    rescue => exception
      return nil
    end
  end

  def self.new_price(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    begin
      client.price(ticker_symbol)
    rescue => exception
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.search(param)
    param.strip!
    to_send_back = (ticker_matches(param) + name_matches(param)).uniq
    return nil unless to_send_back
    to_send_back
  end

  def self.ticker_matches(param)
    matches('ticker', param)
  end

  def self.name_matches(param)
    matches('name', param)
  end

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

end
