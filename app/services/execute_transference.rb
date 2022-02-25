class ExecuteTransference
  def initialize(params)
    @params = params
    @sender = Account.find(params[:sender_id])
    @receiver = Account.find(params[:receiver_id])
  end

  def self.perform(*args)
    new(*args).perform
  end

  def perform
    transference = Transference.new(params)
    Account.transaction do
      sender.last_balance.update!(balance: sender_balance - transference.amount)
      receiver.last_balance.update!(balance: receiver_balance + transference.amount)
      transference.save
    end
    transference
  end

  private

  def sender_balance
    sender.last_balance.balance
  end

  def receiver_balance
    receiver.last_balance.balance
  end

  attr_reader :sender, :receiver, :amount, :params
end
