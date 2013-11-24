require 'geocoder'

namespace :adhoc do
  BING_API_KEY = ""
  GOOGLE_API_KEY = ""
  task :geocode_stops => [:environment] do
    Geocoder.configure(lookup: :bing, api_key: BING_API_KEY)
    Stop.find_each do |stop|
      next if StopCity.exists?(stop_id: stop.id)

      pt = [stop.lat, stop.lon]
      result = Geocoder.search(pt.join(','))
      if result.present?
        first_result = result.first
        city = first_result.city
        address = first_result.address
        StopCity.create(stop_id: stop.id, city: city, address: address)
        puts "Created stop_city (#{city}) for stop id #{stop.id}"
      end
    end
  end

  task :translate_stop_cities => [:environment] do
    EasyTranslate.api_key = GOOGLE_API_KEY
    StopCity.where('city is not null').where(city_hebrew: nil).group_by { |sc| sc.city }.map do |name, cities|
      city_hebrew = EasyTranslate.translate(name, from: :en, to: :he)
      ids = cities.map { |sc| sc.id }
      StopCity.where(id: ids).update_all(city_hebrew: city_hebrew)
      puts "Translated stop_city to (#{city_hebrew.reverse}) for #{cities.count} stop cities"
    end
  end
end
