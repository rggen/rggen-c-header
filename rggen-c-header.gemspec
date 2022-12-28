# frozen_string_literal: true

require File.expand_path('lib/rggen/c_header/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'rggen-c-header'
  spec.version = RgGen::CHeader::VERSION
  spec.authors = ['Taichi Ishitani']
  spec.email = ['rggen@googlegroups.com']

  spec.summary = "rggen-c-header-#{RgGen::CHeader::VERSION}"
  spec.description = 'C header file writer plugin for RgGen'
  spec.homepage = 'https://github.com/rggen/rggen-c-header'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/rggen/rggen/issues',
    'mailing_list_uri' => 'https://groups.google.com/d/forum/rggen',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/rggen/rggen-c-header',
    'wiki_uri' => 'https://github.com/rggen/rggen/wiki'
  }

  spec.files =
    `git ls-files lib LICENSE CODE_OF_CONDUCT.md README.md`.split($RS)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
end
