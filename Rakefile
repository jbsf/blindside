
def build_dir(effective_platform_name)
  File.join(BUILD_DIR, CONFIGURATION + effective_platform_name)
end

def system_or_exit(cmd, stdout = nil)
  puts "Executing #{cmd}"
  cmd += " >#{stdout}" if stdout
  system(cmd) or raise "******** Build failed ********"
end

def with_env_vars(env_vars)
  old_values = {}
  env_vars.each do |key,new_value|
    old_values[key] = ENV[key]
    ENV[key] = new_value
  end

  yield

  env_vars.each_key do |key|
    ENV[key] = old_values[key]
  end
end

def output_file(target)
  output_dir = if ENV['IS_CI_BOX']
    ENV['CC_BUILD_ARTIFACTS']
  else
    Dir.mkdir(BUILD_DIR) unless File.exists?(BUILD_DIR)
    BUILD_DIR
  end

  output_file = File.join(output_dir, "#{target}.output")
  puts "Output: #{output_file}"
  output_file
end

def kill_simulator
  system %Q[killall -m -KILL "gdb"]
  system %Q[killall -m -KILL "otest"]
  system %Q[killall -m -KILL "iPhone Simulator"]
end

task :default => [:trim_whitespace, :build_ios_dynamic_test, :specs, :focused_specs, :uispecs]
task :cruise => [:clean, :build_all, :specs, :focused_specs, :uispecs]

desc "Trim whitespace"
task :trim_whitespace do
  system_or_exit %Q[git status --short | awk '{if ($1 != "D" && $1 != "R") print $2}' | grep -e '.*\.[cmh]$' | xargs sed -i '' -e 's/	/    /g;s/ *$//g;']
end

desc "Clean all targets"
task :clean do
  system_or_exit "xcodebuild -project #{PROJECT_NAME}.xcodeproj -alltargets -configuration #{CONFIGURATION} clean SYMROOT=#{BUILD_DIR}", output_file("clean")
end

desc "Build application"
task :build_app do
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{APP_NAME} -configuration #{CONFIGURATION} build SYMROOT=#{BUILD_DIR}], output_file("app"))
end

desc "Bump version number"
task :bump_version do
  system_or_exit(%Q[agvtool bump -all])
end

desc "Package application"
task :package_app => :build_app do
  system_or_exit(%Q[/usr/bin/xcrun -sdk iphoneos PackageApplication -v "#{BUILD_DIR}/Release-iphoneos/#{APP_NAME}.app" -o "#{BUILD_DIR}/#{APP_NAME}.ipa" --sign "#{DEVELOPER_NAME}" --embed "#{PROVISIONING_PROFILE}"])
  system_or_exit(%Q[cd #{BUILD_DIR}/Release-iphoneos; zip -r ../#{APP_NAME}.app.dSYM.zip #{APP_NAME}.app.dSYM])
end

namespace :testflight do
  desc "Deploy to TestFlight"
  task :deploy => [:clean, :bump_version, :package_app] do
    print "Deploy Notes: "
    message = STDIN.gets

    system_or_exit(%Q[curl http://testflightapp.com/api/builds.json \
                      -F file=@#{BUILD_DIR}/#{APP_NAME}.ipa \
                      -F dsym=@#{BUILD_DIR}/#{APP_NAME}.app.dSYM.zip \
                      -F api_token='#{TESTFLIGHT_API_TOKEN}' \
                      -F team_token='#{TESTFLIGHT_TEAM_TOKEN}' \
                      -F notes='#{message}' \
                      -F notify=True \
                      -F distribution_lists='#{TESTFLIGHT_DISTRIBUTION_LISTS}'])
  end
end

desc "Build specs"
task :build_specs do
  puts "SYMROOT: #{ENV['SYMROOT']}"
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{SPECS_TARGET_NAME} -configuration #{CONFIGURATION} build SYMROOT=#{BUILD_DIR}], output_file("specs"))
end

desc "Build iOS Dynamic Framework test"
task :build_ios_dynamic_test do
  puts "SYMROOT: #{ENV['SYMROOT']}"
  kill_simulator
  system_or_exit(%Q[xcodebuild -project Blindside.xcodeproj -target 'Blindside-iOS-Framework BuildTest' build SYMROOT=#{BUILD_DIR}], output_file("framework_build"))
end

desc "Build UI specs"
task :build_uispecs do
  kill_simulator
  system_or_exit "xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{UI_SPECS_TARGET_NAME} -configuration #{CONFIGURATION} -sdk iphonesimulator build", output_file("uispecs")
end

desc "Build all targets"
task :build_all do
  kill_simulator
  system_or_exit "xcodebuild -project #{PROJECT_NAME}.xcodeproj -alltargets -configuration #{CONFIGURATION} build TEST_AFTER_BUILD=NO SYMROOT=#{BUILD_DIR}", output_file("build_all")
end

desc "Run specs"
task :specs => :build_specs do
  build_dir = build_dir("")
  with_env_vars("DYLD_FRAMEWORK_PATH" => build_dir, "CEDAR_REPORTER_CLASS" => "CDRColorizedReporter") do
    system_or_exit("cd #{build_dir}; ./#{SPECS_TARGET_NAME}")
  end
end

desc "Run focused specs"
task :focused_specs do
  # This target was made just for testing focused specs mode
  # and should not be created in applications that want to use Cedar.

  focused_specs_target_name = "FocusedSpecs"
  system_or_exit "xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{focused_specs_target_name} -configuration #{CONFIGURATION} build SYMROOT=#{BUILD_DIR}", output_file("focused_specs")

  build_dir = build_dir("")
  ENV["DYLD_FRAMEWORK_PATH"] = build_dir
  ENV["CEDAR_REPORTER_CLASS"] = "CDRColorizedReporter"
  system_or_exit File.join(build_dir, focused_specs_target_name)
end

require 'tmpdir'

desc "Run UI specs"
task :uispecs => :build_uispecs do
  env_vars = {
    "DYLD_ROOT_PATH" => SDK_DIR,
    "IPHONE_SIMULATOR_ROOT" => SDK_DIR,
    "CFFIXED_USER_HOME" => Dir.tmpdir,
    "CEDAR_HEADLESS_SPECS" => "1",
    "CEDAR_REPORTER_CLASS" => "CDRColorizedReporter",
  }

  with_env_vars(env_vars) do
    system_or_exit "#{File.join(build_dir("-iphonesimulator"), "#{UI_SPECS_TARGET_NAME}.app", UI_SPECS_TARGET_NAME)} -RegisterForSystemEvents";
  end
end


