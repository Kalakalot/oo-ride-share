require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips, :status
    
    def initialize(id:, name:, vin:, trips: [], status: :AVAILABLE)
      super(id)
      
      # valid_status = [:AVAILABLE, :UNAVAILABLE]
      @name = name
      @vin = vin
      @trips = trips || []
      @status = status.to_sym
      
      if vin.length != 17
        raise ArgumentError.new("The vin must be 17 characters long")
      end
      
      unless status == :AVAILABLE || status ==:UNAVAILABLE
        raise ArgumentError, "Please choose between AVAILABLE OR UNAVAILABLE"
      end
    end
    
    def add_trip(trip)
      trips << trip
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