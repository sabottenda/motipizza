
all:

init:
	bundle install --path vendor/bundler 

clean:
	@find . -name '*~' | xargs rm -f

server:
	bundle exec ruby web.rb -o 0.0.0.0
