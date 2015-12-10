workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup DefaultRackup
environment 'production'
bind 'unix:///var/run/apartment-intercom-adapter.sock'
tag 'apartment-intercom-adapter'
