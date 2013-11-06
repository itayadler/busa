require 'faraday'

class SIRIService
  APPLICATION_ID = 'IA200020' #BusAwesome application id in SIRI
  REQUEST_TEMPLATE = <<-XML
    <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:acsb="http://www.ifopt.org.uk/acsb" xmlns:datex2="http://datex2.eu/schema/1_0/1_0" xmlns:ifopt="http://www.ifopt.org.uk/ifopt" xmlns:siri="http://www.siri.org.uk/siri" xmlns:siriWS="http://new.webservice.namespace" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="./siri">
        <SOAP-ENV:Header />
        <SOAP-ENV:Body>
            <siriWS:GetStopMonitoringService>
                <Request xsi:type="siri:ServiceRequestStructure">
                    <siri:RequestTimestamp>%{now}</siri:RequestTimestamp>
                    <siri:RequestorRef xsi:type="siri:ParticipantRefStructure">%{requestor_ref}</siri:RequestorRef>
                    <siri:StopMonitoringRequest version="IL2.6" xsi:type="siri:StopMonitoringRequestStructure">
                        <siri:RequestTimestamp>%{now}</siri:RequestTimestamp>
                        <siri:MessageIdentifier xsi:type="siri:MessageQualifierStructure">9</siri:MessageIdentifier>
                        <siri:PreviewInterval>PT1H</siri:PreviewInterval>
                        <siri:MaximumStopVisits>%{maximum_stop_visits}</siri:MaximumStopVisits>
                    </siri:StopMonitoringRequest>
                </Request>
            </siriWS:GetStopMonitoringService>
        </SOAP-ENV:Body>
    </SOAP-ENV:Envelope>
  XML
  def self.get_stop_monitoring_service
    conn = Faraday.new(url: 'http://81.218.41.99:8081')
    conn.post do |req|
      req.url '/Siri/SiriServices'
      req.headers['Content-Type'] = 'text/xml'
      req.body = REQUEST_TEMPLATE % { now: Time.now.utc.iso8601(10), requestor_ref: APPLICATION_ID, maximum_stop_visits: 1000.to_s }
    end
  end
end
