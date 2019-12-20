class Oystercard

  attr_reader :balance, :max_balance, :min_balance, :minimum_charge,
              :entry_station, :exit_station, :journeys, :in_journey, :current_journey

  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MINIMUM_CHARGE = 1

  ERROR = { min: 'Not enough money on Oystercard'

  }
  def initialize()
    @balance = 0
    @journeys = []
    @current_journey = {}
    @in_journey = false 
  end

  def top_up(amount)
    raise "Balance cannot exceed £#{MAX_BALANCE}" if @balance >= MAX_BALANCE
    @balance += amount
  end

  def touch_in(station)
    fail ERROR[:min] if @balance < MIN_BALANCE
    @entry_station = station
  end

  def touch_out(station)
    deduct(MINIMUM_CHARGE)
    @exit_station = station
    update_journey_history
    @entry_station = nil
  end

  def in_journey?
    !@entry_station || !@exit_station
  end

  def update_journey_history
    @current_journey = { :entry_station => @entry_station, :exit_station => @exit_station }
    @journeys << @current_journey
  end 
  
  private

  def deduct(amount)
    @balance -= amount
  end
end
