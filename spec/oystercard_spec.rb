require 'oystercard'

describe Oystercard do

  describe '#initialize' do
    it "has a balance of zero" do
        expect(subject.balance).to eq(0)
    end
  end

  describe '#top_up' do

    it 'can top up balance' do
      expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
    end

    it "raises an error if the max balance is exceeded" do
      max_balance = Oystercard::MAX_BALANCE
      subject.top_up(max_balance)
      expect { subject.top_up 1 }.to raise_error "Balance cannot exceed £#{max_balance}"
    end
  end

  it 'is initially not in journey' do
    expect(subject).not_to be_in_journey
  end

  it 'reduces the Oystercard balance by minimum balance' do
    subject.top_up(10)
    subject.touch_in
    expect{ subject.touch_out }.to change{ subject.balance }.by (-Oystercard::MINIMUM_CHARGE)
  end

describe "#touch_in" do
  it 'can touch in' do
    subject.top_up(Oystercard::MAX_BALANCE)
    subject.touch_in
    expect(subject).to be_in_journey
  end

  it 'raises an error' do
    expect { subject.touch_in }.to raise_error 'Not enough money on Oystercard'
  end
end


  it 'can touch out' do
    subject.top_up(Oystercard::MAX_BALANCE)
    subject.touch_in
    subject.touch_out
    expect(subject).not_to be_in_journey
  end
lala

end
