print("Simulated Annealing with Lua\n" .. 
  "Ahmad Arsyel A.\n")
math.randomseed(os.time()) -- memastikan nilai random

local function random_float(lower, greater) -- fungsi random range float
    return lower + math.random()  * (greater - lower)
end

local function generate_value(x1,x2) -- fungsi soal
  local inExp = math.abs(1-math.sqrt(x1^2+x2^2)/math.pi)
  local _sin = math.sin(x1)
  local _cos = math.cos(x2)
  return -math.abs(_sin*_cos*math.exp(inExp))
end

local function generate_new_random(x) -- memanipulasi pergerakan nilai random
  local val
  repeat
    val = x + random_float(-1,1) -- lakukan analisis modifikasi
  until (val >= -10) and (val <= 10) -- lakukan pengulangan selama range nilai benar
  return val
end

local function probability(delta,temperature) -- fungsi probabilitas
  return math.exp(-delta/temperature)
end

-- inisiasi variable
local T = 100 -- inisiasi suhu
local Tx = 0.0001 -- minimal suhu, lakukan analisis
local cooling = 0.001 -- pengurangan T tiap iterasi, lakukan analisis
local x1 = random_float(-10,10)
local x2 = random_float(-10,10)
local new_x1
local new_x2
local best_x1
local best_x2
local curr_state = generate_value(x1,x2) -- inisiasi variable nilai terminimum
local best_state = curr_state -- menyimpan state terbaik global

local function save_state(x,y,state) -- menyimpan state dan parameternya
  curr_state = state
  x1 = x
  x2 = y
end

local function save_best_state(x,y,state) -- menyimpan state terbaik global
  best_state = state
  best_x1 = x
  best_x2 = y
end

local function annealing()
  new_x1 = generate_new_random(x1)
  new_x2 = generate_new_random(x2)
  
  local next_state = generate_value(new_x1,new_x2) -- variable dengan nilai baru dari fungsi soal
  local delta = next_state - curr_state
  if delta < 0 then -- jika next_state lebih minimum
    save_state(new_x1,new_x2,next_state) -- menyimpan state terbaik local
    save_best_state(x1,x2,curr_state)
  else -- jika lebih besar, hitung prababilitasnya
    local P = probability(delta,T)
    local a = math.random()
    if a < P then
      save_state(new_x1,new_x2,next_state) -- menyimpan state berdasarkan probabilitas
    end
  end
  --print("T:",T,"\nx1:",x1,"\nx2:",x2,
  --"\nNilai:",curr_state,"\n")
end

print("Sedang mencari nilai terminimum...")

while T > Tx do
  for i = 1, 10 do -- pengulangan tiap suhu yang sama, lakukan analisis
    annealing()
  end
  T = T - (T * cooling) -- pengurangan temperatur (deltaT) tiap iterasi, cooling rate
end

print("Solusi terbaik :" .. best_state .. " --> (" .. best_x1 .. ", " .. best_x2 .. ")")
print(best_state,">>>",(best_state / -19.2085)* 100,"%") -- debug
