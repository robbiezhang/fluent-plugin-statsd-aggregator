Gem::Specification.new do |s|
  s.name        = 'fluent-plugin-statsd-aggregator'
  s.version     = '0.0.1'
  s.date        = '2016-08-09'
  s.summary     = 'FluentD Output Plugin as StatsD server'
  s.description = 'Implement the StatsD server aggregation logic, and wrap it in a FluentD output plugin. The aggregated data will be converted to OMS PerfCounter format.'
  s.authors     = 'robbiezhang'
  s.email       = 'junjiez@microsoft.com'
  s.files       = ['lib/fluent/plugin/statsd_lib.rb', 'lib/fluent/plugin/out_statsd-aggregator.rb']
  s.homepage    = '//https://github.com/robbiezhang/fluent-plugin-statsd-aggregator'
  s.license     = 'MIT'

  s.required_ruby_version = Gem::Requirement.new(">= 1.9".freeze)
  
  s.add_runtime_dependency 'fluentd', '>= 0.12.24', '< 0.14'
end
