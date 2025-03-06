#internet関係 設定
wlan = WLAN.new('STA')
wlan.connect("RubyCamp", "shimanekko")

#距離センサ設定
i2c = I2C.new()             # I2Cシリアルインターフェース初期化
vl53l0x = VL53L0X.new(i2c)  # 距離センサー（VL53L0X）
vl53l0x.set_timeout(500)    # タイムアウト値設定（単位: ms）

#ボールつかんでいたら1,つかんでいなかったら0
ball=0;

#ビジュアライザーの初期化
HTTP.get( "http://192.168.6.32:3000/position?op=abs&x=400&y=435")


class Kanirobo

  def initialize

    p "initialize"
    # 右モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
    @rm_pin1 = PWM.new(25,timer:0,channel:1) # 右モーターPIN1
    @rm_pin2 = PWM.new(26,timer:0,channel:2) # 右モーターPIN2

    # 左モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
    @lm_pin1 = PWM.new(32,timer:1,channel:3) # 左モーターPIN1
    @lm_pin2 = PWM.new(33,timer:1,channel:4) # 左モーターPIN2

    @servo = PWM.new(27, timer:2, channel:5, frequency:50) # 右サーボモーター
    @servo2 = PWM.new(14, timer:2, channel:6, frequency:50) # 左サーボモーター


    p "initialize end"
  end

  def open_aram
    @servo.pulse_width_us(800)
    @servo2.pulse_width_us(2499)
  end

  def close_aram
    @servo.pulse_width_us(2300)
    @servo2.pulse_width_us(800)
  end

  def forword_longsidehalf
    @lm_pin1.duty(34)
    @lm_pin2.duty(0)
    @rm_pin1.duty(30)
    @rm_pin2.duty(0)
    sleep 2.5 # 1.0秒間待機
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
    sleep 0.1
  end

  def forword_longside
    p "forword_longside"
    # 左右モーター出力100%正回転
    @lm_pin1.duty(34)
    @lm_pin2.duty(0)
    @rm_pin1.duty(30)
    @rm_pin2.duty(0)
    sleep 4.6 # 1.0秒間待機
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
    sleep 0.1
  end

  def forword_shortsidehalf
    @lm_pin1.duty(31)
    @lm_pin2.duty(0)
    @rm_pin1.duty(30)
    @rm_pin2.duty(0)
    sleep 0.8 # 1.0秒間待機
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
    sleep 0.1
  end

  def forword_shortside
    # 左右モーター出力100%正回転
    @lm_pin1.duty(31)
    @lm_pin2.duty(0)
    @rm_pin1.duty(30)
    @rm_pin2.duty(0)
    sleep 3.7
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
    sleep 0.1
  end

  def turn_left
    # 左回転(90度)
    @lm_pin1.duty(72)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(72)
    sleep 2.1
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
  end

  def turn_right
    #右回転(90度)
    @lm_pin1.duty(100)
    @lm_pin2.duty(72)
    @rm_pin1.duty(72)
    @rm_pin2.duty(100)
    sleep 2.4
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
  end

  def stop
    # 左右モーター停止
    @lm_pin1.duty(100)
    @lm_pin2.duty(100)
    @rm_pin1.duty(100)
    @rm_pin2.duty(100)
  end

end

kanirobo = Kanirobo.new

#{}HTTP.get( "http://192.168.6.32:3000/angle?value=20&target=Kani1")
#{}kanirobo.forword_longside()

#START->D
kanirobo.open_aram()
kanirobo.forword_longsidehalf()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_longsidehalf&value=0.0&target=Kani1")
kanirobo.turn_right()
HTTP.get( "http://192.168.6.32:3000/movement?string=stop&value=90.0&target=Kani1")
kanirobo.forword_shortsidehalf()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_shortsidehalf&value=0.0&target=Kani1")
kanirobo.forword_shortside()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_shortside&value=0.0&target=Kani1")
kanirobo.stop()
kanirobo.open_aram()

#ここでボールがDにあったときの分岐
if !vl53l0x.init
  puts "initialize failed"
else
    vl53l0x.start_continuous(100)
  distance = vl53l0x.read_range_continuous_millimeters
  p "ball:#{distance}mm"
  if distance < 70
    ball=1;
     1.times do
        kanirobo.close_aram()
        HTTP.get( "http://192.168.6.32:3000/movement?string=ServoClosed&value=0.0&target=Kani1")
    end
   end
  #ボールを掴む処理
end
#D->GOAL

#D->B
#kanirobo.open_aram()
if ball == 0
    kanirobo.open_aram()
    p "open arm"
end
kanirobo.forword_shortside()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_shortside&value=0.0&target=Kani1")
kanirobo.forword_shortside()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_shortside&value=0.0&target=Kani1")
kanirobo.stop()
#ここでボールがDにあったときの分岐
if !vl53l0x.init
  puts "initialize failed"
else
    vl53l0x.start_continuous(100)
  distance = vl53l0x.read_range_continuous_millimeters
  p "ball:#{distance}mm"
  if distance < 70
    ball=1;
     1.times do
        kanirobo.close_aram()
        HTTP.get( "http://192.168.6.32:3000/movement?string=ServoClosed&value=0.0&target=Kani1")
    end
  end
  #ボールを掴む処理
end
if ball == 1
    kanirobo.close_aram()
    p "close arm"
end
#B->GOAL

#B->A
#kanirobo.open_aram()
if ball == 0
    p "no ball"
    kanirobo.open_aram()
    p "open arm"
end
kanirobo.forword_shortside()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_shortside&value=0.0&target=Kani1")
kanirobo.turn_left()
HTTP.get( "http://192.168.6.32:3000/movement?string=stop&value=-90.0&target=Kani1")
kanirobo.forword_longside()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_longside&value=0.0&target=Kani1")
kanirobo.stop()
#ここでボールがDにあったときの分岐
if !vl53l0x.init
  puts "initialize failed"
else
    vl53l0x.start_continuous(100)
  distance = vl53l0x.read_range_continuous_millimeters
  p "ball:#{distance}mm"
  if distance < 70
    ball=1;
         1.times do
            kanirobo.close_aram()
            HTTP.get( "http://192.168.6.32:3000/movement?string=ServoClosed&value=0.0&target=Kani1")
        end
   end
  #ボールを掴む処理

end
if ball==1
    kanirobo.close_aram()
    p "close arm"
end
#A->GOAL

#A->C
#kanirobo.open_aram()
if ball==0
    p "no ball"
    kanirobo.open_aram()
end
if ball==1
    kanirobo.close_aram()
    p "close arm"
end
kanirobo.turn_left()
HTTP.get( "http://192.168.6.32:3000/movement?string=stop&value=-90.0&target=Kani1")
kanirobo.forword_shortside()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_shortside&value=0.0&target=Kani1")
kanirobo.forword_shortside()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_shortside&value=0.0&target=Kani1")
kanirobo.turn_right()
HTTP.get( "http://192.168.6.32:3000/movement?string=stop&value=90.0&target=Kani1")
kanirobo.forword_longside()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_longside&value=0.0&target=Kani1")
kanirobo.stop()
if ball==1
    kanirobo.close_aram()
    p "close arm"
end
#ここでボールが見つかってない場合の分岐
#C->E

#C->GOAL

kanirobo.forword_longside()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_longside&value=0.0&target=Kani1")
kanirobo.forword_longside()
HTTP.get( "http://192.168.6.32:3000/movement?string=forword_longside&value=0.0&target=Kani1")
kanirobo.stop()
HTTP.get( "http://192.168.6.32:3000/movement?string=stop&value=0.0&target=Kani1")
