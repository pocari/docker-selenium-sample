require 'selenium-webdriver'

#webdriver操作用のユーティリティ
def with_webdriver
  driver = Selenium::WebDriver.for(
    :remote,
    url: "http://192.168.99.100:4444/wd/hub",
    desired_capabilities: :chrome
  )

  # implict_waitを設定しておくとfind_elementなどで描画待ちでまだ取得できない場合などに待ってくれる
  driver.manage.timeouts.implicit_wait = 10

  yield driver
ensure
  driver.quit
end

with_webdriver do |d|
  # gooleにアクセス
  d.navigate.to "https://www.google.co.jp"

  # 検索ボックス取得
  search_box = d.find_element(id: "lst-ib")

  # 検索ボックスに検索ワードを入れて
  search_box.send_keys("docker selenium-webdriver")
  # enter押下
  search_box.send_keys(:return)

  # 検索結果の見出しはclassが"r"のdivに囲まれた"a"タグのようなのでそれを全部表示
  d.find_elements(:class, "r").each do |result|
    puts result.text
  end

  # この状態をスクリーンショットで保存
  d.save_screenshot "google_search_result.png"
end

