require 'selenium-webdriver'

def with_webdriver
  driver = Selenium::WebDriver.for(
    :remote,
    url: "http://192.168.99.100:4444/wd/hub",
    desired_capabilities: :chrome
  )
  driver.manage.timeouts.implicit_wait = 10
  yield driver
ensure
  driver.quit
end

def wait_until(&b)
  w = Selenium::WebDriver::Wait.new(:timeout => 10)
  w.until(&b)
end

def wait_until_download(file)
  wait_until do 
    prev_size = -1
    wait_until do
      if File.exists?(file)
        size = File.size(file)
        ret = if size == prev_size
                true
              else
                prev_size = size
                false
              end
        sleep 1
        ret
      end
    end
  end
end

with_webdriver do |d|
  d.navigate.to "http://www.post.japanpost.jp/zipcode/dl/oogaki-zip.html"

  # ダウンロードリンク取得
  link = d.find_element(:xpath, "//*[@href='oogaki/zip/01hokkai.zip']")
  link.click

  begin
    # ダウンロードを待つ
    path = "./downloads/01hokkai.zip"
    wait_until_download(path)

    # ダウンロードしたファイルを使う
    p [path, File.size(path)]
  ensure
    # 終わったらダウンロード削除
    File.delete(path) if File.exists?(path)
  end
end

