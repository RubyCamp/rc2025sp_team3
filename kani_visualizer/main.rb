require 'singleton'
require 'gosu'

require_relative 'server'
require_relative 'characters'

# ゲームのメインウィンドウ（メインループ）用クラス
class MainWindow < Gosu::Window
  include Singleton
  # 各種定数定義
  WIDTH = 503
  HEIGHT = 535
  FULL_SCREEN = false

  # コンストラクタ
  def initialize
    super WIDTH, HEIGHT, FULL_SCREEN
    self.caption = 'Kani Visualizer'
    @background = Gosu::Image.new("images/FieldTrue.png")
    @kani1 = Kani1.instance
    @kani1.visible = true
    @kani1.set_pos(400, 435)
    @kani1.set_angle(180)
    @ball = Ball.instance
    @ball.visible = false
    @temp1 = Temp1.instance
    @temp1.visible = true
    @temp2 = Temp2.instance
    @temp2.visible = false

    @characters = [@kani1, @ball, @temp1, @temp2]

    @font = Gosu::Font.new(32, name: "DelaGothicOne-Regular.ttf")
  end

  # 1フレーム分の更新処理
  def update
    exit if Gosu.button_down?(Gosu::KB_ESCAPE)
  end

  # 1フレーム分の描画処理
  def draw
    @background.draw(0, 0, 0)
    @characters.each do |character|
      character.draw if character.visible
    end
    @font.draw_text(@distance, 10, 10, 0, 1.0, 1.0, 0xff_ff0000) if @distance
    end
  
  # キャラクタとボールの距離情報を画面上に表示する
  def distance(distance)
    puts "距離来た"
    @distance = distance
  end
end

# Webrickサーバ開始
Server.new.run

# メインウィンドウ表示
window = MainWindow.instance
window.show
