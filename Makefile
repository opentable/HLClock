lint:
	pod lib lint

test:
	set -o pipefail && xcodebuild test -workspace Example/HLClock.xcworkspace -scheme HLClock-Example -destination 'platform=iOS Simulator,name=iPhone 8,OS=12.0' ONLY_ACTIVE_ARCH=NO | xcpretty

travis: lint test
