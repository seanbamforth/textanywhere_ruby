Gem::Specification.new do |s|
  s.name               = "textanywhere_ruby"
  s.version            = "0.1.1"
  s.default_executable = "textanywhere_ruby"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sean Bamforth"]
  s.date = %q{2012-05-04}
  s.description = %q{Library to communicate with TextAnywhere.net}
  s.email = %q{sean@theguru.co.uk}
  s.files = ["Rakefile", "lib/textanywhere_ruby.rb", "bin/textanywhere_ruby"]
  s.test_files = ["test/test_textanywhere_ruby.rb"]
  s.homepage = %q{http://rubygems.org/gems/textanywhere_ruby}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{textanywhere_ruby!}

  s.add_dependency('nokogiri', '>= 1.5.0')
end