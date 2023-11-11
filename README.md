# Eletric-Cars

## Explicando a função code

  Na função go foi criada uma condição que quando o ticks for igual a 'study_time' * 100 o programa irá parar de rodar.

```nlogo

if ticks = (study_time * 100) [
	stop
]

```


  Por isso foi criado e definido n = 100, para que no loop while seja realizado uma ação a cada 100 ticks.

```nlogo

let n 100

if ( ticks >= 100 and ticks mod n = 0) [
	...
]

```

### Dentro da condição

  Na primeira linha foi definido 'consumption_annual_per_car' como 0 para que todo ano a conta se reinicie e não vire um somatório de todos os anos.
  Nas linhas seguintes foi criado e definido uma série de listas onde será armazenado os dados de acordo com o nome.

```nlogo

set consumption_annual_per_car 0
let consumption_median []
let battery_capacity_kWh []
let charger_power_kWh []
let km_been []

```

Foi criada uma váriavel chama x para ser usada como o número atual do carro sendo analizado.
Usando a variável x foi criado um loop que irá rodar até que x seja igual ao número total de carros.

```nlogo
let x 0

while [ x < cars_num] [
	...
]
```

De acordo com a sua localização irá ser usado diferentes parâmetros na geração de um número aleatório para a variável 'charger_power_KWh'.
```
* location = 1: Significa que o carro está sendo carregado em uma casa com 110V.
* location = 2: Significa que o carro está sendo carregado em uma casa com 220V.
* location = 3: Significa que o carro está sendo carregado em um posto de alta potência.
```
```nlogo

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

```

De acordo com o tipo de uso do carro é gerado um número aleatório que será usado como seu km rodado por ano.

```
* type_car = 1: Significa que o carro é usado somente dentro da cidade.
* type_car = 2: significa que o carro é usado de forma mista, tanto na cidade quanto fora.
* type_car = 3: significa que o carro é usado somente para viagens.
* type_car = 4: significa que o carro é usado de forma comercial, para alguma empresa.
```
```nlogo

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

```

###

##
