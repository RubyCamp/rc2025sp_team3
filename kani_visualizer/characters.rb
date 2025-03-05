require 'singleton'

# 視覚化対象の共通クラス
class Character
  # シングルトンクラス化
  # ref: https://docs.ruby-lang.org/ja/latest/class/Singleton.html
  include Singleton

  # インスタンス外から設定変更を許可するアクセサ定義
  attr_accessor :x, :y, :angle, :image, :visible

  # コンストラクタ
  def initialize
    set_image
    @visible = false
    @x = 0
    @y = 0
    @angle = 0
    @radian = 0
    @distance = 0
  end

  # キャラクタの座標を上書きする
  def set_pos(x, y)
    @x, @y = x, y
  end

  # キャラクタの座標を増減させる
  def add_pos(dx = 0, dy = 0)
    @x += dx
    @y += dy
  end

  # キャラクタの回転角を上書きする
  def set_angle(angle)
    @angle = angle
  end

  # キャラクタの回転角を増減させる
  def add_angle(da)
    @angle += da
  end

  # キャラクタ画像を画面上に表示するかどうかを変更する
  def set_visible(visible)
    @visible = visible
  end

  # キャラクタの動作ごとに画面上の座標と角度を変更する
  def movement(move, angle)
    @angle += angle
    @radian = @angle / 180.0 * Math::PI
    case move
    #when 'turn_right'
    #  add_angle(90)
    #when 'turn_left'
    #  add_angle(-90)
    when 'forword_shortside'
      cos = Math.cos(@radian) * 71.25
      sin = Math.sin(@radian) * 71.25
      add_pos(cos, sin)
    when 'forword_longside'
      cos = Math.cos(@radian) * 71.25
      sin = Math.sin(@radian) * 71.25
      add_pos(cos, sin)
    when 'stop'
      add_pos(0,0)
    end
  end

  # キャラクタとボールの距離情報を画面上に表示する
  def distance(distance)
    @font.draw_text(distance, 10, 10, 0, 1.0, 1.0, 0xff_ff0000)
  end

  # キャラクタ画像をウィンドウに描画
  def draw
    @image.draw_rot(@x, @y, 0, @angle)
  end

  private

  # キャラクタ画像を設定する
  # NOTE: 継承先においてオーバーライドし、サブクラス毎に固有の画像を設定できるようにしている。
  def set_image
    raise "override me"
  end
end

# 視覚化対象クラス（蟹ロボ1台目）
# ※ 本サンプルでは１台のみ表示するためKani2は作らない。
class Kani1 < Character
  private

  # 蟹ロボの固有画像を設定するようオーバーライド
  def set_image
    @image = Gosu::Image.new("images/kani.png")
  end
end

# 視覚化対象クラス（ボール）
class Ball < Character
  private

  # ボールの固有画像を設定するようオーバーライド
  def set_image
    @image = Gosu::Image.new("images/ball.png")
  end
end