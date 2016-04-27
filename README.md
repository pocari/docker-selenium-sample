# docker-selenium-sample
dockerでseleniumを使うサンプル

- bundle install
- docker run -d -v $(pwd)/downloads:/home/seluser/Downloads -p 4444:4444 -p 5900:5900 selenium/standalone-chrome-debug:2.53.0
- bundle exec ruby download-zip.rb
