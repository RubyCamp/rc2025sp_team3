#internet関係 設定
wlan = WLAN.new('STA')
wlan.connect("RubyCamp", "shimanekko")

#距離センサ設定
i2c = I2C.new()             # I2Cシリアルインターフェース初期化
vl53l0x = VL53L0X.new(i2c)  # 距離センサー（VL53L0X）
vl53l0x.set_timeout(500)    # タイムアウト値設定（単位: ms）

class Kanirobo

  def initialize

    p "initialize"
    # 右モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
    @rm_pin1 = PWM.new(25,timer:0,channel:1) # 右モーターPIN1
    @rm_pin2 = PWM.new(26,timer:0,channel:2) # 右モーターPIN2

    # 左モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
    @lm_pin1 = PWM.new(32,timer:1,channel:3) # 左モーターPIN1
    @lm_pin2 = PWM.new(33,timer:1,channel:4) # 左モーターPIN2

    p "initialize end"
  end

  def forword_longsidehalf
    @lm_pin1.duty(30)
    @lm_pin2.duty(0)
    @rm_pin1.duty(30)
    @rm_pin2.duty(0)
    sleep 1.5 # 1.0秒間待機
  end

  def forword_longside
    p "forword_longside"
    # 左右モーター出力100%正回転
    @lm_pin1.duty(30)
    @lm_pin2.duty(0)
    @rm_pin1.duty(30)
    @rm_pin2.duty(0)
    sleep 3.0 # 1.0秒間待機
    p "forword_longside end"
  end

  def forword_shortsidehalf
    @lm_pin1.duty(30)
    @lm_pin2.duty(0)
    @rm_pin1.duty(30)
    @rm_pin2.duty(0)
    sleep 0.8 # 1.0秒間待機
  end

  def forword_shortside
    # 左右モーター出力100%正回転
    @lm_pin1.duty(30)
    @lm_pin2.duty(0)
    @rm_pin1.duty(30)
    @rm_pin2.duty(0)
    sleep 2.8
  end  

  def turn_left
    # 左回転(90度)
    @lm_pin1.duty(0)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(0)
    sleep 0.3
  end

  def turn_right
    #右回転(90度)
    @lm_pin1.duty(100)
    @lm_pin2.duty(0)
    @rm_pin1.duty(0)
    @rm_pin2.duty(100)
    sleep 0.25
  end

  def stop
    # 左右モーター停止
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
  end

end

kanirobo=Kanirobo.new


HTTP.get( "http://192.168.6.32:3000/movement?string=forword_longside&value=0.0&target=Kani1")
p "send movement"
HTTP.get( "http://192.168.6.32:3000/movement?string=stop&value=60.0&target=Kani1")
p "send movement"

#{}HTTP.get( "http://192.168.6.32:3000/angle?value=20&target=Kani1")
#{}kanirobo.forword_longside()

#START->D
kanirobo.forword_longsidehalf()
kanirobo.turn_right()
kanirobo.forword_shortsidehalf()
kanirobo.forword_shortside()
kanirobo.stop()

#ここでボールがDにあったときの分岐
if !vl53l0x.init
  puts "initialize failed"
else
  distance = vl53l0x.read_range_continuous_millimeters
  p "ball:#{distance}mm"
  if distance > 300
  #ボールを掴む処理
end
#D->GOAL

#D->B
kanirobo.forword_shortside()
kanirobo.forword_shortside()
kanirobo.stop()
#ここでボールがDにあったときの分岐
if !vl53l0x.init
  puts "initialize failed"
else
  distance = vl53l0x.read_range_continuous_millimeters
  p "ball:#{distance}mm"
  if distance > 300
  #ボールを掴む処理
end
#B->GOAL

#B->A
kanirobo.forword_shortside()
kanirobo.turn_left()
kanirobo.forword_longside()
kanirobo.stop()
#ここでボールがDにあったときの分岐
if !vl53l0x.init
  puts "initialize failed"
else
  distance = vl53l0x.read_range_continuous_millimeters
  p "ball:#{distance}mm"
  if distance > 300
  #ボールを掴む処理
end
#A->GOAL

#A->C
kanirobo.turn_left()
kanirobo.forword_shortside()
kanirobo.forword_shortside()
kanirobo.turn_right()
kanirobo.forword_longside()
kanirobo.stop()
#ここでボールが見つかってない場合の分岐
#C->E

#C->GOAL
kanirobo.forword_longside()
kanirobo.forword_longside()
kanirobo.stop()


