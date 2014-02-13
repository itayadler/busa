set :output, "#{path}/log/cron.log"

every 1.day, :at => '3:00 am' do
  rake 'import:all'
end
