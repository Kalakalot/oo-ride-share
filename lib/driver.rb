require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :trips, :status
    
    def initialize(id:, name:, vin:, trips: nil, status: :AVAILABLE)
      super(id)
      
      @name = name
      @vin = vin
      @trips = trips || []
      @status = status.to_sym
      
      if @vin.length != 17
        raise ArgumentError.new("The vin must be 17 characters long")
      end
      
      # raise argument errors for driver statuses that aren't available or unavailable
      unless @status == :AVAILABLE || @status == :UNAVAILABLE
        raise ArgumentError, "Please choose between AVAILABLE OR UNAVAILABLE"
      end
    end
    
    def add_trip(trip)
      @trips << trip
    end
    
    def average_rating
      total = 0.0
      if trips.length == 0
        return 0
      end
      trips.each do |trip|
        total += trip.rating 
      end
      return total / trips.length
    end
    
    def total_revenue
      
      # Pull trip costs out of driver's trips array 
      gross_revenue_array = []
      trips.each do |trip|
        gross_revenue_array << trip.cost
      end
      
      # Multiply number of trips by trip fee ($1.65)
      total_fees = gross_revenue_array.length * 1.65
      
      # Subtract total fees from gross revenue, then return 80% of that
      driver_earnings = (gross_revenue_array.sum - total_fees) * 0.80
      
      return driver_earnings
    end
    
    def self.from_csv(record)
      return self.new(id: record[:id],
        name: record[:name],
        vin: record[:vin],
        status: record[:status]
      )
    end
  end
end