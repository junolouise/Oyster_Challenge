require 'oystercard'

describe Oystercard do

  describe '#initialize' do
    it "has a balance of zero" do
        expect(subject.balance).to eq(0)
    end
  end

  describe '#top_up' do
    
    let(:entry_station) { double :station }

    it 'can top up balance' do
      expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
    end

    it "raises an error if the max balance is exceeded" do
      Oystercard::MAX_BALANCE.times{ subject.top_up(1) }
      expect{ subject.top_up(@balance) }.to raise_error "Balance cannot exceed £#{Oystercard::MAX_BALANCE}"
    end
  end

  describe "#touch_in" do
  
     let(:entry_station) { double :station }
     it { is_expected.to respond_to(:top_up).with(1).argument}

     it 'stores the entry station' do
       subject.top_up(5)
       subject.touch_in(:station)
       expect(subject.entry_station).to eq :station
     end

     it 'can touch in' do
       subject.top_up(Oystercard::MAX_BALANCE)
       subject.touch_in(:station)
       expect(subject).to be_in_journey
      end

     it 'Not enough money on Oystercard' do
       expect { subject.touch_in(:entry_station) }.to raise_error Oystercard::ERROR[:min]
     end
   
      it 'remembers a station on touch in' do
        touch_in = double("touch_in")
        subject.top_up(Oystercard::MAX_BALANCE)
        subject.touch_in(:station)
        expect(subject.entry_station).to eq :station
      end
  end

  it 'raises an error' do
    expect { subject.touch_in(:station) }.to raise_error Oystercard::ERROR[:min]
  end

  describe "#touch_out" do 
    let(:entry_station) { double :station }
    let(:exit_station) { double :station }
    let(:journey){ {entry_station: entry_station, exit_station: exit_station} }

     it 'can touch out' do
      subject.top_up(5)
      subject.touch_in(:station)
      subject.touch_out(:station)
      expect(subject.entry_station).to eq nil
    end
   
    it 'reduces the Oystercard balance by minimum balance' do
      subject.top_up(20)
      expect{ subject.touch_out(:station) }.to change{ subject.balance }.by (-Oystercard::MINIMUM_CHARGE)
    end
  end

    describe "#deduct" do
  
      let(:entry_station) { double :station }

      it 'reduces the Oystercard balance by minimum balance' do
        subject.top_up(10)
        expect{ subject.touch_out(:station) }.to change{ subject.balance }.by (-Oystercard::MINIMUM_CHARGE)
      end

    end

    describe "#in_journey" do

      it 'checks if user is in journey' do
        expect(subject).to be_in_journey
      end
    end

    describe "#update_journey_history" do

    let(:entry_station) { double :station }

    it 'stores the @entry_station as the value of entry_station key inside hash' do
      subject.top_up(5)
      subject.touch_in(:station)
      subject.update_journey_history
      expect(subject.current_journey[:entry_station]).to eq subject.entry_station
    end
    end



  end