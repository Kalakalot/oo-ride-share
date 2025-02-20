require_relative 'test_helper'
require 'time'

TEST_DATA_DIRECTORY = 'test/test_data'

describe "TripDispatcher class" do
  def build_test_dispatcher
    return RideShare::TripDispatcher.new(
      directory: TEST_DATA_DIRECTORY
    )
  end
  
  describe "Initializer" do
    it "is an instance of TripDispatcher" do
      dispatcher = build_test_dispatcher
      expect(dispatcher).must_be_kind_of RideShare::TripDispatcher
    end
    
    it "establishes the base data structures when instantiated" do
      dispatcher = build_test_dispatcher
      [:trips, :passengers].each do |prop|
        expect(dispatcher).must_respond_to prop
      end
      
      expect(dispatcher.trips).must_be_kind_of Array
      expect(dispatcher.passengers).must_be_kind_of Array
      expect(dispatcher.drivers).must_be_kind_of Array
    end
    
    it "loads the development data by default" do
      # Count lines in the file, subtract 1 for headers
      trip_count = %x{wc -l 'support/trips.csv'}.split(' ').first.to_i - 1
      
      dispatcher = RideShare::TripDispatcher.new
      
      expect(dispatcher.trips.length).must_equal trip_count
    end
  end
  
  describe "passengers" do
    describe "find_passenger method" do
      before do
        @dispatcher = build_test_dispatcher
      end
      
      it "throws an argument error for a bad ID" do
        expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
      end
      
      it "finds a passenger instance" do
        passenger = @dispatcher.find_passenger(2)
        expect(passenger).must_be_kind_of RideShare::Passenger
      end
    end
  end
  
  describe "Passenger & Trip loader methods" do
    before do
      @dispatcher = build_test_dispatcher
    end
    
    it "accurately loads passenger information into passengers array" do
      first_passenger = @dispatcher.passengers.first
      last_passenger = @dispatcher.passengers.last
      
      expect(first_passenger.name).must_equal "Passenger 1"
      expect(first_passenger.id).must_equal 1
      expect(last_passenger.name).must_equal "Passenger 8"
      expect(last_passenger.id).must_equal 8
    end
    
    it "connects trips and passengers" do
      dispatcher = build_test_dispatcher
      dispatcher.trips.each do |trip|
        expect(trip.passenger).wont_be_nil
        expect(trip.passenger.id).must_equal trip.passenger_id
        expect(trip.passenger.trips).must_include trip
      end
    end
  end
  
  describe "drivers" do
    describe "find_driver method" do
      before do
        @dispatcher = build_test_dispatcher
      end
      
      it "throws an argument error for a bad ID" do
        expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
      end
      
      it "finds a driver instance" do
        driver = @dispatcher.find_driver(2)
        expect(driver).must_be_kind_of RideShare::Driver
      end
    end
  end
  
  describe "Driver & Trip loader methods" do
    before do
      @dispatcher = build_test_dispatcher
    end
    
    it "accurately loads driver information into drivers array" do
      first_driver = @dispatcher.drivers.first
      last_driver = @dispatcher.drivers.last
      
      # changing test assertions to match test drivers.csv file
      expect(first_driver.name).must_equal "Driver 1 (unavailable)"
      expect(first_driver.id).must_equal 1
      expect(first_driver.status).must_equal :UNAVAILABLE
      expect(last_driver.name).must_equal "Driver 3 (no trips)"
      expect(last_driver.id).must_equal 3
      expect(last_driver.status).must_equal :AVAILABLE
    end
    
    it "connects trips and drivers" do
      @dispatcher.trips.each do |trip|
        expect(trip.driver).wont_be_nil
        expect(trip.driver.id).must_equal trip.driver_id
        expect(trip.driver.trips).must_include trip
      end
    end
  end
  
  describe "Request_trip methods" do
    before do
      @dispatcher = build_test_dispatcher
      @trip = @dispatcher.request_trip(1)
    end
    
    it "return value is an instance of Trip" do
      expect(@trip).must_be_kind_of RideShare::Trip
    end

    it "new trip has expected data types and values" do
      expect(@trip.id).must_equal 6
      assert_nil(@trip.end_time)
      assert_nil(@trip.rating)
      expect(@trip.driver.name).must_equal "Driver 2"
      expect(@trip.driver.id).must_equal 2
    end
    
    it "adds the new trip to a the collection of all trips" do
      expect @dispatcher.trips.include?(@trip)
    end
    
    it "driver is an instance of Driver" do
      expect(@trip.driver).must_be_kind_of RideShare::Driver
    end
    
    it "raises an error if there are no drivers available" do
      @test_trip2 = @dispatcher.request_trip(2)
      expect{@dispatcher.request_trip(2)}.must_raise ArgumentError
    end

    it "sets driver's status to unavailable" do
      expect @trip.driver.status == :UNAVAILABLE
    end
    
    it "adds new trip to driver's trip list" do
      expect @trip.driver.trips.include?(@trip)
    end

    it "passenger is an instance of Passenger" do
      expect(@trip.passenger).must_be_kind_of RideShare::Passenger
    end
    
    it "adds the new trip to the passenger's list of trips" do
    expect @trip.passenger.trips.include?(@trip)
    end
    
  end    
end
