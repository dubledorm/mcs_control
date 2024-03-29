# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :job_template, "sh -c ':job'"

every 1.day, at: '7:00 am' do
  rake "health_request:do_request", :output => {:standard => "/dev/null 2>&1"}
end

every 1.day, at: '3:00 am' do
  rake "stored_files:delete_old", :output => {:standard => "/dev/null 2>&1"}
end

