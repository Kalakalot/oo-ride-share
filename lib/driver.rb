require 'csv'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status
    
    def initialize(id:, name:, vin:, trips: nil, status: :AVAILABLE)
      super(id)
      @name = name,
      @vin = vin,
      @trips = trips,
      @status = status
    end
    
    
    
  end
end