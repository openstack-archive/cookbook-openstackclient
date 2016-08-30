#  encoding: UTF-8
#
#  Copyright 2016 cloudbau GmbH
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

task default: ['test']

task test: [:lint, :style, :unit]

desc 'Run FoodCritic (lint) tests'
task :lint do
  sh %(chef exec foodcritic --epic-fail any .)
end

desc 'Run RuboCop (style) tests'
task :style do
  sh %(chef exec rubocop)
end

desc 'Run RSpec (unit) tests'
task :unit do
  sh %(chef exec rspec --format documentation)
end
