; torna as variáveis globais, fazendo com que possa usar elas em qualquer lugar do programa
globals [ consumption_annual_total  cars_num consumption_annual_per_car]

; função responsável por configurar o default do programa e/ou reiniciar ele
to setup

  ; limpa o que tiver para ser limpo no programa
  clear-all

  ; define o número atual de carros como "initial_cars"
  set cars_num initial_cars

  ; cria um número fixo de tartarugas que serão mostradas na tela do programa
  create-turtles 50 [
    ; define a aparência das tartarugas como "van top"
    set shape "van top"
  ]

  ; reiniciar a contagem de ticks para 0
  reset-ticks
end

; função responsável por iniciar o programa
to go

  ; chama a função code e faz com que quando rodar a função go, também rode a função code
  code

  ; chama a função random_walk e faz com que quando rodar a função go, também rode a função random_walk
  random_walk

  ; define o tempo máximo que o programa vai rodar
  if ticks = (study_time * 100) [
    stop
  ]

  ; soma mais 1 a contagem de tick
  tick
end

; função responsável pelo loop do programa e calculo do mesmo
to code

  ; define n como 100 para ser usada como divisor na linha abaixo
  let n 100

  ; faz com que a cada 100 ticks seja realizado as contas de consumo, crescimento de carros e etc..
  if ( ticks >= 100 and ticks mod n = 0) [

    set consumption_annual_per_car 0 ; define o consumo anual por carro como 0
    let consumption_median [] ; cria uma lista de consumo medios (para todos os carros)
    let battery_capacity_kWh [] ; cria uma lista de capacidade da bateria (para todos os carros)
    let charger_power_kWh [] ; cria uma lista de poder de carregamento ( para todos os carros)
    let km_been [] ; cria uma lista contendo os km rodados (para todos os carros)

    ; define x como 0 para ser usado como indicador do carro atual que está sendo analizado (maximo = cars_num)
    let x 0
    ; define o loop como sendo até o número do carro sendo analizado ser igual ao total de carros
    while [ x < cars_num] [

      ; com os dados obtidos da interface é gerado um número aleatório e em seguida adicionado a lista de consumo médio
      set consumption_median lput ( random-float ( consumption_median_max - consumption_median_min ) + consumption_median_min ) consumption_median
      ; com os dados obtidos da interface é gerado um número aleatório e em seguida adicionado a lista de capacidade da bateria
      set battery_capacity_kWh lput ( random ( battery_capacity_max - battery_capacity_min + 1 ) + battery_capacity_min ) battery_capacity_kWh
      ; gera um número aleatório entre 1 a 3 para ser usado como localização de carregamento do carro
      let location random 3 + 1
      ; gera um número aleatório entre 1 a 4 para ser usado como o tipo de uso do carro
      let type_car random 4 + 1

      ; analiza qual a localização de carregamento do carro para definir qual vai ser sua potencia de carregamento
      (ifelse
        location = 1 [
          set charger_power_kWh lput ( random-float ( residencial110V_charger_power_max - residencial110V_charger_power_min) + residencial110V_charger_power_min ) charger_power_kWh
        ]
        location = 2 [
          set charger_power_kWh lput ( random (residencial220V_charger_power_max - residencial220V_charger_power_min) + residencial220V_charger_power_min ) charger_power_kWh
        ]
        location = 3 [
          set charger_power_kWh lput ( random ( highvoltage_charger_power_max - highvoltage_charger_power_min) + highvoltage_charger_power_min ) charger_power_kWh
        ]
        ; elsecommands
        [
          show "An Error has ocurred!!!"
      ])

      ; analiza qual o tipo de uso do carro para definir quantos km o carro vai rodar por ano
      (ifelse
        type_car = 1 [
          set km_been lput ( random ( urban_km_been_max - urban_km_been_min + 1 ) + urban_km_been_min ) km_been
        ]
        type_car = 2 [
          set km_been lput ( random ( mixed_km_been_max - mixed_km_been_min + 1 ) + mixed_km_been_min ) km_been
        ]
        type_car = 3 [
          set km_been lput ( random ( highdistance_km_been_max - highdistance_km_been_min + 1 ) + highdistance_km_been_min ) km_been
        ]
        type_car = 4 [
          set km_been lput ( random ( commercial_km_been_max - commercial_km_been_min + 1 ) + commercial_km_been_min ) km_been
        ]
        ; elsecommands
        [
          show "An Error has ocurred!!!"
      ])

      ; define de quantos em quantos dias é carregado o carro
      let charger_freq_day random 3 + 1
      ; define quantos vezes por dia é carregado o carro
      let charger_freq random 4 + 1
      ; define quanto tempo demora pra carregar a bateria do carro de 0 a 100
      let charger_time ( ( item x battery_capacity_kWh ) / ( item x charger_power_kWh ))
      ; define o tempo de carregamento anual
      let charger_annual_time (charger_time * ((365 / charger_freq_day) * charger_freq))

      ; define o consumo anual por carro
      set consumption_annual_per_car ( consumption_annual_per_car  + (( item x consumption_median - (item x consumption_median * (random-float ( consumption_improvement_max - consumption_improvement_min ) + consumption_improvement_min)) ) * ( item x km_been ) * ( charger_annual_time - (charger_annual_time * ( random-float ( charger_improvement_max - charger_improvement_min ) + charger_improvement_min))) ))

      ; atualiza o valor de x, indicando que ja acabou de analizar o carro atual
      set x ( x + 1)
    ]

    ; se for definido um valor para a váriavel "growth_car_rate_fix", faz com que somente esse valor seja usado na conta
    (ifelse
      growth_car_rate_fix != 0 [
        set cars_num ((cars_num * growth_car_rate_fix + cars_num) - (cars_num * ( random-float destroy_car_rate)))
      ]
      ; elsecommands
      [
        ; se não foi definido, faz com que um valor aleatório seja usado
        set cars_num ((cars_num * ( (random-float (growth_cars_rate_max - growth_cars_rate_min) + growth_cars_rate_min)) + cars_num ) - (cars_num * ( random-float destroy_car_rate)))

    ])

    ; show round cars_num

    ; faz com que seja anotado na central de comandos o valor atual de consumo anual por carro
    type round ( consumption_annual_per_car / ( 10 ^ 9) )
    print " GWh"

    ; define o consumo anual total como sendo o consumo anual por carro
    set consumption_annual_total ( consumption_annual_per_car )

  ]


end

; função responsavel por fazer as tartarugas ficarem se movendo aleatóriamente na tela
to random_walk

  ask turtles [

    set heading ( heading + 45 - (random 90))
    forward 1

  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
8
10
498
501
-1
-1
14.61
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
60.0

BUTTON
13
517
76
550
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
113
518
176
551
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
516
281
767
341
initial_cars
10000.0
1
0
Number

INPUTBOX
517
355
633
415
growth_cars_rate_min
0.3738
1
0
Number

SLIDER
209
517
496
550
study_time
study_time
1
100
10.0
1
1
NIL
HORIZONTAL

PLOT
517
11
770
198
cars_growth
years
cars
0.0
10.0
0.0
50000.0
false
false
"set-plot-x-range 0 study_time\n" "if (cars_num >= 50000) [\n\nset-plot-y-range 0 (round cars_num + 10000)\n\n]"
PENS
"cars_num" 1.0 0 -2674135 false "" "plotxy (ticks / 100) (round cars_num)"

MONITOR
516
222
768
267
cars_num
round cars_num
17
1
11

INPUTBOX
650
353
767
414
growth_cars_rate_max
0.9261
1
0
Number

MONITOR
1069
220
1326
265
consumption_annual_total_GWh
round ( consumption_annual_total / (10 ^ 9))
17
1
11

INPUTBOX
516
425
767
486
growth_car_rate_fix
0.0
1
0
Number

INPUTBOX
516
496
767
556
destroy_car_rate
0.0
1
0
Number

PLOT
1068
10
1325
196
consumption_energy
years
consumption
0.0
10.0
0.0
10000.0
true
false
"set-plot-x-range 0 study_time" "if ( ( consumption_annual_total / (10 ^ 9 )) >= 50000) [\n\nset-plot-y-range 0 (round ( consumption_annual_total / (10 ^ 9)) + 10000)\n\n]"
PENS
"default" 1.0 0 -16777216 false "" "plotxy ( ticks / 100) ( consumption_annual_total / (10 ^ 9) )"

INPUTBOX
1200
278
1328
338
consumption_improvement_max
0.11
1
0
Number

INPUTBOX
1069
278
1188
338
consumption_improvement_min
0.05
1
0
Number

INPUTBOX
1070
352
1189
412
charger_improvement_min
0.02
1
0
Number

INPUTBOX
1202
352
1331
412
charger_improvement_max
0.06
1
0
Number

INPUTBOX
1070
423
1191
483
consumption_median_min
0.2
1
0
Number

INPUTBOX
1203
422
1332
482
consumption_median_max
0.5
1
0
Number

INPUTBOX
1070
495
1191
555
battery_capacity_min
40.0
1
0
Number

INPUTBOX
1204
495
1332
555
battery_capacity_max
90.0
1
0
Number

INPUTBOX
1350
34
1505
94
residencial110V_charger_power_min
1.2
1
0
Number

INPUTBOX
1518
34
1673
94
residencial110V_charger_power_max
2.5
1
0
Number

INPUTBOX
1349
107
1504
167
residencial220V_charger_power_min
6.0
1
0
Number

INPUTBOX
1518
106
1673
166
residencial220V_charger_power_max
18.0
1
0
Number

INPUTBOX
1351
181
1506
241
highvoltage_charger_power_min
40.0
1
0
Number

INPUTBOX
1519
181
1674
241
highvoltage_charger_power_max
100.0
1
0
Number

INPUTBOX
788
41
912
101
urban_km_been_min
5000.0
1
0
Number

INPUTBOX
923
41
1055
101
urban_km_been_max
10000.0
1
0
Number

INPUTBOX
788
115
911
175
mixed_km_been_min
5000.0
1
0
Number

INPUTBOX
922
115
1055
175
mixed_km_been_max
20000.0
1
0
Number

INPUTBOX
788
191
912
251
highdistance_km_been_min
5000.0
1
0
Number

INPUTBOX
924
191
1054
251
highdistance_km_been_max
30000.0
1
0
Number

INPUTBOX
788
268
912
328
commercial_km_been_min
5000.0
1
0
Number

INPUTBOX
926
268
1055
328
commercial_km_been_max
40000.0
1
0
Number

TEXTBOX
890
10
1040
28
km per year
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

van top
true
0
Polygon -7500403 true true 90 117 71 134 228 133 210 117
Polygon -7500403 true true 150 8 118 10 96 17 85 30 84 264 89 282 105 293 149 294 192 293 209 282 215 265 214 31 201 17 179 10
Polygon -16777216 true false 94 129 105 120 195 120 204 128 180 150 120 150
Polygon -16777216 true false 90 270 105 255 105 150 90 135
Polygon -16777216 true false 101 279 120 286 180 286 198 281 195 270 105 270
Polygon -16777216 true false 210 270 195 255 195 150 210 135
Polygon -1 true false 201 16 201 26 179 20 179 10
Polygon -1 true false 99 16 99 26 121 20 121 10
Line -16777216 false 130 14 168 14
Line -16777216 false 130 18 168 18
Line -16777216 false 130 11 168 11
Line -16777216 false 185 29 194 112
Line -16777216 false 115 29 106 112
Line -7500403 false 210 180 195 180
Line -7500403 false 195 225 210 240
Line -7500403 false 105 225 90 240
Line -7500403 false 90 180 105 180

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
