# 右モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
@rm_pin1 = PWM.new(25,timer:0,channel:1) # 右モーターPIN1
@rm_pin2 = PWM.new(26,timer:0,channel:2) # 右モーターPIN2

# 左モーター初期化（引数のGPIO番号は全ての蟹ロボで共通）
@lm_pin1 = PWM.new(32,timer:1,channel:3) # 左モーターPIN1
@lm_pin2 = PWM.new(33,timer:1,channel:4) # 左モーターPIN2

i2c = I2C.new()             # I2Cシリアルインターフェース初期化
vl53l0x = VL53L0X.new(i2c)  # 距離センサー（VL53L0X）
vl53l0x.set_timeout(500)    # タイムアウト値設定（単位: ms）

def
    @rm_pin1.duty = 30
    @rm_pin2.duty = 0
    @lm_pin1.duty = 30
    @lm_pin2.duty = 0
end

def
    @rm_pin1.duty = 0
    @rm_pin2.duty = 0
    @lm_pin1.duty = 0
    @lm_pin2.duty = 0
end

target_distance = 100

loop do
    distance = vl53l0x.read_range_continuous_millimeters
    puts "距離: #{distance} mm"

    if distance > target_distance

    sleep 0.1
end
