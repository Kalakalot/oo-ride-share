require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :id, :name, :vin, :trips
    attr_accessor :status
    
    def initialize(id:, name:, vin:, trips: nil, status: :AVAILABLE)
      super(id)
      
      # valid_status = [:AVAILABLE, :UNAVAILABLE]
      @name = name,
      @vin = vin,
      @trips = trips || [],
      @status = status.to_sym
      
      
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