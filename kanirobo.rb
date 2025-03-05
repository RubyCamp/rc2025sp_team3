wlan = WLAN.new('STA')
wlan.connect("RubyCamp", "shimanekko")

class Kanirobo

  def initialize

    p "initialize"
    # 右モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
    @rm_pin1 = PWM.new(25) # 右モーターPIN1
    @rm_pin2 = PWM.new(26) # 右モーターPIN2

    # 左モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
    @lm_pin1 = PWM.new(32) # 左モーターPIN1
    @lm_pin2 = PWM.new(33) # 左モーターPIN2

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
    sleep 2.0
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
    sleep 0.33
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


HTTP.get( "http://192.168.6.32:3000/movement?string=turn_right&value=20.0&target=Kani1")
p "send movement"
#{}HTTP.get( "http://192.168.6.32:3000/angle?value=20&target=Kani1")
#{}kanirobo.forword_longside()

#START->D
kanirobo.forword_longsidehalf()
kanirobo.stop()
kanirobo.turn_right()
kanirobo.stop()
kanirobo.forword_shortsidehalf()
kanirobo.stop()
kanirobo.forword_shortside()
kanirobo.stop()

#ここでボールがDにあったときの分岐
#D->B
kanirobo.forword_shortside()

