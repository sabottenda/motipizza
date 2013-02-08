
all:

init:
	bundle install --path vendor/bundler 

clean:
	@find . -name '*~' | xargs rm -f
