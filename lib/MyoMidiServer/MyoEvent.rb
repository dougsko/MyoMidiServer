require 'json'

class MyoEvent
    attr_accessor :pose, :orientData, :accelData, :diffData, :worldData, 
        :gyroData, :timeStamp
    
    def initialize(event_text)
        event = JSON.parse(event_text) rescue {}
        @pose = event['pose']
        @orientData = event['orientData']
        @accelData = event['accelData']
        @diffData = event['diffData']
        @worldData = event['worldData']
        @gyroData = event['gyroData']
        @timeStamp = event['timeStamp'].first rescue []
    end   
end
