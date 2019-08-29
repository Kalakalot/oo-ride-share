require_relative 'test_helper'

describe "Passenger class" do
  
  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end
    
    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end
    
    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end
    
    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end
      
      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end
  
  
  describe "trips property" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip = RideShare::Trip.new(
        id: 8,
        #added this to aid in all other tests
        passenger: @passenger,
        # Julia's note: not sure if syntax below is correct
        start_time: Time.parse('2016-08-08'),
        end_time: Time.parse('2016-08-09'),
        rating: 5
      )
      
      @passenger.add_trip(trip)
    end
    
    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end
    
    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
    
    it "net_expenditures" do
      #grab a passenger instance example
      #find 2 trips and add to the passenger
      #ADD (method)
      #have an array of trip costs 
      #when adding, add by array
      #passenger.trips at the index
      #make a variable to shovel the answer into
      #add the expect with the new variable with the .net_expenditures with the total amount needed.
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
      @driver = RideShare::Driver.new(id: 54, name: "Test Driver", vin: "12345678901234567", status: :AVAILABLE)
      trip1 = RideShare::Trip.new( id: 8, driver: @driver, driver_id: 4, passenger_id: 3, start_time: Time.parse("2016-08-08"), end_time: Time.parse("2016-08-09"), cost: 2, rating: 1)
      trip2 = RideShare::Trip.new( id: 8, driver: @driver, passenger_id: 3, start_time: Time.parse("2016-08-08"), end_time: Time.parse("2016-08-09"), cost: 4, rating: 1)
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      expect(passenger.net_expenditures).must_equal 6
    end
  end
  
  
  
  
end
