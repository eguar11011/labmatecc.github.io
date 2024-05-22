### A Pluto.jl notebook ###
# v0.19.39

using Markdown
using InteractiveUtils

# ╔═╡ 3a89574c-06c9-45b2-8e7e-54a550c26db0
using PlutoUI

# ╔═╡ a5d1beba-f053-4c35-a5c9-686c6cc67302
using Plots, LinearAlgebra, Optim, DifferentialEquations, Distributions, Statistics

# ╔═╡ 920785ba-c91c-4697-84f6-5abdbab026a6
PlutoUI.TableOfContents(title="Vaciado de tanque", aside=true)

# ╔═╡ 24244d99-613e-47fb-b53b-2dc21536a568
md"""Este cuaderno esta en construcción y puede ser modificado en el futuro para mejorar su contenido. En caso de comentarios o sugerencias por favor escribir a jcgalvisa@unal.edu.co

Tu participación es fundamental para hacer de este curso una experiencia aún mejor."""

# ╔═╡ 6815c72f-7456-4756-b228-36bb634157c8
md"""Elaborado por Juan Galvis, Francisco Gómez, Carlos Nosa y Yessica Trujillo. El cuaderno fue inspirado en [4]."""

# ╔═╡ 622563c7-4137-4af5-82bb-c57e854bfaa0
md"""Usaremos las siguientes librerías:"""

# ╔═╡ 19597282-84ea-4bcb-8611-1092535b1b9d
md"""# Modelo del vaciado del tanque"""

# ╔═╡ 89502336-92b1-443b-a74e-519a533f7b17
md"""Se analizarán los datos recopilados de un experimento en video [1] para ilustrar y cuantificar cómo varía la altura (expresada en centímetros) de una columna de agua en un cilindro (de radio $r_1$) a medida que transcurre el tiempo (medido en segundos), considerando que dicho cilindro tiene un pequeño agujero circular (de radio $r_2$) en la parte inferior del cilindro por donde el agua se escapa. Este análisis también se realizará para el experimento del video [2].

Modelemos el flujo de salida del agua del cilindro. Para esto consideremos el Principio de Bernoulli

$P_1+\rho g h_1 +\frac{1}{2}\rho v_1^2 = P_2 +\rho g h_2 +\frac{1}{2}\rho v_2^2.$
Donde $P_1, P_2$ denotan la presión en la altura inicial y la altura del agujero, respectivamente. $\rho$ denota la densidad del fluido. $h_1, h_2$ representan la altura inicial del liquido y la atura del agujero, respectivamente. $v_1$ denota la velocidad con la que baja el agua en el intante inicial y $v_2$ la velocidad con la que sale el agua por el agujero. $g$ representa la gravedad.

Note que $P_1=P_2=P_{atm}$, donde $P_{atm}$ es la presión atmosférica, además $v_1=0$ y como el liquido con el que se esta trabajando es el agua, entonces $\rho=1$. Así

$g h_1 =  g h_2 +\frac{1}{2}\rho v_2^2.$

Dado que la aceleración de la gravedad no es constante sobre la superficie de la Tierra, entonces midamos este cambio respecto al valor estándar con ayuda del parámetro $\epsilon$, de esta forma se tiene que

$(g+\epsilon) h_1 =  (g+\epsilon) h_2 +\frac{1}{2}\rho v_2^2.$
Sea $v=v_2$, se sigue que

$v=\sqrt{2(g+\epsilon)(h_1-h_2)}.$
Esta igualdad es conocida como la Ley de Torricelli.

Ahora bien, dado que en un pequeño intervalo de tiempo $\Delta t$ se tiene que

$V(t+\Delta t)=V(t)-\pi r_2^2v\Delta t,$
donde $V(t)$ denota el volumen del agua en el instante $t$, de esto se sigue que

$\dfrac{V(t+\Delta t)-V(t)}{\Delta t}=-\pi r_2^2v,$
así

$\lim_{\Delta t\to 0}\dfrac{V(t+\Delta t)-V(t)}{\Delta t}=-\pi r_2^2v.$
Luego

$\frac{dV}{dt}=-\pi r_2^2v= -\pi r_2^2\sqrt{2(g+\epsilon)(h_1-h_2)}.$
Dado que el volumen del agua en un instante $t$ esta dado por $V(t)=\pi r_1^2h(t)$, entonces derivando con respecto a $t$ se tiene que 

$\frac{dV}{dt}=\dfrac{dV}{dh}\frac{dh}{dt}=\pi r_1^2\frac{dh}{dt},$
así

$-\pi r_2^2\sqrt{2(g+\epsilon)(h_1-h_2)}= \pi r_1^2\frac{dh}{dt},$
esto es

$\frac{dh}{dt}=-\frac{r_2^2\sqrt{2(g+\epsilon)(h_1-h_2)}}{r_1^2}.$

Para nuestros experimentos en este cuaderno vamos a considerar 

$\frac{dh}{dt}=-\alpha\frac{r_2^2\sqrt{2(g+\epsilon)(h_1-h_2)}}{r_1^2}.$
donde $\alpha$ es un número empírico que indica el porcentaje del caudal máximo que realmente atraviesa el orificio pequeño, la reducción debida a la fricción y la constricción en el orificio pequeño. $\alpha$, se llama descarga o coeficiente de contracción.
"""

# ╔═╡ df6d5ba4-574c-44d2-8135-f9366fc4c1bb
md"""## Tanque 1
Los datos recopilados del experimento del video [1] son los siguientes:"""

# ╔═╡ 8409dd37-6f53-4caf-a239-bcaa0c0b79d4
tiempo₁ = [4*i for i in 1:22] #instantes de tiempo (medidos en segundos)

# ╔═╡ f800da38-ef07-48f1-a5b3-de2df7812de0
h1₁ = [11.8, 11.4, 10.9, 10.4, 10, 9.5, 9.1, 8.7, 8.3, 7.9, 7.5, 7.2, 6.8, 6.4, 6.1, 5.8, 5.4, 5.1, 4.7, 4.5, 4.3, 4] #altura del agua en cada instante de tiempo tomado

# ╔═╡ d24cc858-c8b0-46a7-9bc5-316d7e1d922c
g=9.806 #gravedad

# ╔═╡ 1e258c09-aee0-483d-ac5e-9194cdf15455
md"""Visualicemos dichos datos."""

# ╔═╡ 62bd4ba4-25c9-4f91-9d47-e3e7cffea47f
scatter(tiempo₁,h1₁,ls=:dash,label="Altura h₁",lw=4, xlabel = "Tiempo",yaxis="Altura h₁")

# ╔═╡ d09015b3-1920-4820-89a9-da863486f386
md"""### Modelo 1: Modelo lineal
Primero, ajustaremos los datos a un modelo de ecuaciones diferenciales lineal, de la siguiente forma

$\frac{dh}{dt}=-ah.$
Consideremos dicho modelo con la condición inicial $h_4=h(4)=11.8$. Recordemos que deseamos hallar el valor óptimo de $a$."""

# ╔═╡ 56dc1e4e-3d8d-4311-83b0-322ce014ceff
md"""Creamos una función para dicho modelo:"""

# ╔═╡ acf0c3b9-2dd6-430d-b96f-9f4d187db0b7
modelo₁(h₁,par₁,t₁)=-par₁[1]*h₁

# ╔═╡ 7d4b102f-63ab-43fe-a92b-cd2d4040a908
md"""
Si queremos resolver la EDO para determinado valor del parámetro, usamos, 
"""

# ╔═╡ 244bdf17-b4d3-45f2-8fee-ee0494b5123e
begin
	tspan₁=(4,120)
	h₀₁=11.8
	par₁=[1.0]
	EDO₁=ODEProblem(modelo₁,h₀₁,tspan₁,par₁)
	h₁=solve(EDO₁)
	plot(h₁)
end

# ╔═╡ 10490e62-3803-49d0-a927-469ac0a6049d
md"""
#### Estimación de parámetros por medio de optimización
"""

# ╔═╡ d8a47a14-6f91-4ff8-801e-6353205babe9
md"""
Ahora podemos escribir la función residuo del modelo de EDO. Es decir, cacular la norma entre el pronóstico de una EDO con parámetros dados y los datos. 
"""

# ╔═╡ a92f1359-3e09-429c-8874-43abe19d9c05
function residuo₁(par,h,t)
  tspan=(4,120)
  h₀=11.8
  EDO=ODEProblem(modelo₁,h₀,tspan,par)
  hSOL=solve(EDO)
  hI=[hSOL(t) for t in tiempo₁]
  res=h-hI
  nres=norm(res)
return nres
end

# ╔═╡ a5446a93-693b-480c-9420-f6228b4401c7
md"""La función residuo arriba mide el desajuste (o tamaño del residuo) de la simulación de la EDO con respecto a los datos usando mínimos cuadrados, es decir, la norma euclidiana de la diferencia o residuo. 

Por ejemplo, el desajuste de usar $a=1$ en el modelo es de:"""

# ╔═╡ 4c4ded08-363c-4374-9b49-5a6925dda469
residuo₁([1],h1₁,tiempo₁)

# ╔═╡ b7b6b4a2-edef-460b-bc0b-c9f469c02371
md"""
Note que dicho valor es grande, es necesario encontrar el valor óptimo para esto. Para esto, escribimos una función solo del parámetro, 
"""

# ╔═╡ f80df167-98b4-41bf-be80-b85236f07546
r₁(par₁) = residuo₁(par₁,h1₁,tiempo₁)

# ╔═╡ 6c34ebc3-2a75-4007-b7bf-292294c407b8
md"""
Y así podemos optimizar el valor del parámetro, tal como se sigue
"""

# ╔═╡ 644f4678-dd01-49bd-9e9e-356047d8422a
o₁=Optim.optimize(r₁, [.01], NelderMead())

# ╔═╡ 1c6718e7-bbb8-4076-822b-338b2a92a536
o₁.minimizer

# ╔═╡ 1ef3b914-e503-4852-8448-dab30abca49d
md"""
De esto se obtiene que da la EDO optima es
$\frac{dh}{dt}=-0.0118h$

Después de calcular el valor del parámetro óptimo podemos mostrar el ajuste final de nuestro modelo. Como antes, podemos visualizar el ajuste comparándolo con los datos. Para esto tenemos, 
"""

# ╔═╡ c7137e9c-fbd9-483e-bd27-14721eb342fd
begin
	om₁=o₁.minimizer
	EDOoptima₁=ODEProblem(modelo₁,h₀₁,tspan₁,om₁)
	hEDOoptima₁=solve(EDOoptima₁)
	plot(hEDOoptima₁,lw=5,label="EDO optima")
	scatter!(tiempo₁,h1₁,label="Altura",lw=4, xlabel = "Tiempo",yaxis="Altura",legend=:bottomright)
end

# ╔═╡ 4fb8d205-130c-4fde-88ef-ed4d7b014cb5
md"""Ya conociendo al EDO y su solución podemos predecir la altura futura del líquido, por ejemplo la altura que nos da este modelo para $t=2m=120s$ es de:"""

# ╔═╡ 23857984-54a6-4850-b125-6325a9d81616
hEDOoptima₁(120)

# ╔═╡ f7875145-9938-4a42-99fe-744949792ce3
md"""
#### Estimación de parámetros por medio de inferencia bayesiana
"""

# ╔═╡ 03c781d5-395c-41f1-9a4e-f784663167d2
md"""
En primer lugar creamos la función que ejecuta el algoritmo de Metropolis-Hastings Random Walk (MHRW).
"""

# ╔═╡ 94aa1b15-cd3f-4b57-a8a5-880e5ec79768
function MHRW0(np,logenergia,soporte,puntoincial,sd=0.1,iteraciones=10000)
    #np es el número de parámetros a estimar
    #Se usa logenergia para controlar posibles errores numéricos 
    #log energía solo debe depender del vector de parámetros 
    #sd: desviación estándar del camino aleatorio
    samples = rand(np) 
    probabilities = [exp(logenergia(samples[:,end]))]

    Alpha = [0] # tasa de aceptación
    #sd: desviación estándar del camino aleatorio

    # MHRW
    for i in 1:iteraciones
        # Construcción de nuevas muestras con un camino aleatorio normal
        theta = samples[:,end]+ sd*randn(np)
        # Condición del soporte
        if soporte(theta) == false
            alpha = 0
            p2 = exp(logenergia(samples[:,end]))
        else
            p1 = exp(logenergia(theta))
            p2 = exp(logenergia(samples[:,end]))
            alpha = min(1, p1/p2)
        end 

        
        Alpha = hcat(Alpha,alpha)
        u = rand()
        #Selección de muestras
        if u < alpha
            samples = hcat(samples, theta)
            probabilities = hcat(probabilities,p1)
        else
            samples = hcat(samples, samples[:,end])
            probabilities = hcat(probabilities,p2)
        end
    end
    #Sistematic sampling
    initial_position = floor(100*rand())
    leap = 20
    samples_ss = samples[:, Int(initial_position):leap:end]
    probabilities_ss = probabilities[Int(initial_position):leap:end];

    #Estimations
    max_prob, position_ss = findmax(probabilities_ss)
    Max_likelihood = samples_ss[:, position_ss]
    Mean = mean(samples_ss, dims=2)
    return (Max_likelihood,max_prob,Mean,samples_ss,probabilities_ss,Alpha)
end

# ╔═╡ 4c561238-d187-439d-9598-ba3f94046206
md"""
En este caso se está asumiendo que $\frac{dh}{dt}=-ah$, con la condición inicial $h_4=h(4)=11.8$. Sea $H1_1(t;a)$ la solución a este problema que cambia a lo largo del tiempo $t$ y tiene como parámetro a un valor fijo de $a$.

Vamos a suponer que los datos tomados $\{z_{\ell}\}_{\ell=1}^{22}$ a lo largo del tiempo $\{t_{\ell}\}_{\ell=1}^{22}$ son realizaciones aleatorias de una distribución $Normal(\mu,\sigma^2)$ con media $\mu$ y varianza $\sigma^2 \mu^2$. Como queremos comparar el ajuste del modelo $H1_1$ en los datos $\{z_{\ell}\}_{\ell=1}^{22}$ asumimos que la $\mu= H1_1(t;a)$ y $\sigma^2=1$, por lo tanto,

$z_\ell \sim Gamma(H1_1(t_\ell;a),1)$

con $E[z_{\ell}] = H1_1(t_\ell;a)$ y $Var[z_\ell] = H1_1(t_\ell;a)^2$. Por otra parte, para el modelo a priori del parámetro $a$ suponemos que $a$ sigue una distribución $Normal(0,1)$. Con lo dicho anteriormente creamos la función de la energía.
"""

# ╔═╡ 2c082ef8-4c74-4a2d-8683-398c02f1c5d5
md"""
Nótese que esta función de log-energía alcanza un máximo, por ende es posible aplicar el algoritmo MHRW.
"""

# ╔═╡ 2b5f6c4d-8b36-489f-9e78-d33d504e5add
md"""
En este caso obtenemos los valores de máximo a posteriori (MAP) y de media condicional (CM) para el parámetro $a$.
"""

# ╔═╡ ea822ea2-84e8-4a04-b7d9-0756342df25c
md"""
La distribución del parámetro $a$ muestra a continuación.
"""

# ╔═╡ 4f81497c-bde7-4063-b79c-fd855e087087
md"""
Con cada una de las muestras obtenidas del valor de $a$ ajustamos el modelo a los datos.
"""

# ╔═╡ 865765c1-9d6a-4c53-9c90-71175275039b
md"""### Modelo 2: Ley de Torricelli
Recordemos la ecuación obtenida al modelar el problema

$\frac{dh}{dt}=-\alpha\frac{r_2^2\sqrt{2(g+\epsilon)(h_1-h_2)}}{r_1^2}.$
Recordemos que los parámetros que no conocemos son $\alpha$ y $\epsilon$. Estos serán los que deseamos ajustar. Consideremos dicho modelo con la condición inicial $h_4=h(4)=11.8$"""

# ╔═╡ c4fa3de9-a6fe-476b-a1b8-1821c9325255
modelo(h,par,t)=-par[1]*(0.138906/4.17)^2*(2*(g+par[2]))^(1/2)*abs(h-0.5).^(1/2)

# ╔═╡ a934af87-adbf-4ac8-a03a-a312142953c0
md"""Si deseamos encontrar la solución de la ecuación diferencial ordinaria para ciertos valores específicos de los parámetros, empleamos"""

# ╔═╡ d68497bf-cb9a-4b89-b389-22c1c8db443c
begin
	tspan=(4,120)
	h₀=11.8
	par=[1.0,1.0]
	EDO=ODEProblem(modelo,h₀,tspan,par)
	h=solve(EDO)
	plot(h)
end

# ╔═╡ 76745e6d-1edf-4a84-a809-5ecf25dd0776
begin
	function H1₁(a)
		EDO=ODEProblem(modelo₁,h₀,tspan,a)
	  	hSOL=solve(EDO)
	  	hI=[hSOL(t) for t in tiempo₁]
		return hI
	end
	
	function soporte11(a)
		if 0<=a[1]<=0.1
			return true
		else
			return false
		end
	end

	function logenergiaH11(a)
		alpha1 = abs.(H1₁(a))
		log_likelihood = mean(logpdf.(Gamma.(alpha1,1), h1₁))
		log_prior = sum(logpdf(Normal(0,1), a))
		return 1E1*(log_likelihood + log_prior)
	end
end

# ╔═╡ 34b8d249-f4bf-4905-83d6-71358bd70726
plot(-0.02:0.001:0.05,logenergiaH11.(-0.02:0.001:0.05),title="Log-Energía", label=false)

# ╔═╡ 83c1ba16-a3db-40ea-9b9a-5a816af5993f
r1 = MHRW0(1,logenergiaH11,soporte11,[1E-1])

# ╔═╡ 3a087963-7fa2-4286-9107-3bcbffeb6519
begin
	println("Máximo a posteriori: ",r1[1][1])
	println("Media condicional: ", r1[3][1,1])
end

# ╔═╡ d4eb4443-b7ea-4bd5-bbe3-22e23d50763d
begin
	plot10 = histogram(r1[4][1,:],bins=50,label="Distribución de a", title="Información del parámetro a")
	plot10 = plot!([r1[1][1],r1[1][1]],[0,100],label="MAP",lw=4)
	plot10 = plot!([r1[3][1,1],r1[3][1,1]],[0,100],label="CM",lw=4)
	plot(plot10)
end

# ╔═╡ 5ba2baa0-549b-4870-8baf-d08ab9020394
begin
	plot11 = plot(tiempo₁,H1₁(r1[4][1,2]),color="gray82",label=false,z=1)
	for i in 1:10:length(r1[4][1,:])
		plot11 = plot!(tiempo₁,H1₁(r1[4][1,i]),color="gray82",label=false,z=1)
	end
	plot11 = scatter!(tiempo₁,h1₁,label="Altura",lw=4, xlabel = "Tiempo",yaxis="Altura",legend=:bottomright)
	plot11 = plot!(tiempo₁,H1₁(r1[1][1]),label="MAP",lw=3)
	plot11 = plot!(tiempo₁,H1₁(r1[3][1,1]),label="CM",lw=3)
	plot(plot11)
end

# ╔═╡ 2381cd08-bf19-47dc-b5d3-7627abc895ce
md"""
#### Estimación de parámetros por medio de optimización
"""

# ╔═╡ d9a8afc4-ade1-41e2-a3b5-472aeb2790c2
md"""La función residuo mide el desajuste (o tamaño del residuo) entre la simulación de la ecuación diferencial ordinaria y los datos mediante mínimos cuadrados, representando la norma euclidiana de la diferencia o residuo."""

# ╔═╡ 0898c191-dc45-471d-b988-60135cb7a88f
function residuo(par,h,t)
  tspan=(4,120)
  h₀=11.8
  EDO=ODEProblem(modelo,h₀,tspan,par)
  hSOL=solve(EDO)
  hI=[hSOL(t) for t in tiempo₁]
  res=h-hI
  nres=norm(res)
return nres
end

# ╔═╡ 796208c6-6ce9-4bc0-b98e-2e366c7ec7b4
md"""Por ejemplo el desajuste de usar $\alpha=1$ y $\epsilon=1$ en el modelo es de:"""

# ╔═╡ 67734a1f-b02d-4144-be59-cb61de57cfe0
 residuo([1 1],h1₁,tiempo₁)

# ╔═╡ dd5a71c3-78c3-4fa5-beba-f683a5e7637c
md"""Ahora, usemos optimización para calcular el valor del parámetro óptimo aproximado. Para esto creamos una función solo del parámetro,"""

# ╔═╡ f1bc02fa-86a3-4daa-9d80-649503629158
r(par) = residuo(par,h1₁,tiempo₁)

# ╔═╡ 2611045a-5466-4201-ad0d-835c82b7b262
md"""y, optimizamos su valor"""

# ╔═╡ 6f630848-8d83-4bf0-a9d0-ef3a974d6038
o=Optim.optimize(r, [.01, .01], NelderMead())

# ╔═╡ e556edc7-a57f-42b5-9c00-e8ec04b21126
o.minimizer

# ╔═╡ 4427f969-9512-466e-adf4-dc86193b328d
md"""Obteniendo así que los valores optimos para $\alpha$ y $\epsilon$ son $6.8085$ y $1.3328$, respectivamente. 

Luego 

$\frac{dh}{dt}=-6.8085\frac{r_2^2\sqrt{2(g+1.3328)(h_1-h_2)}}{r_1^2}.$
Después de calcular el valor del parámetro óptimo podemos mostrar el ajuste final de nuestro modelo. """

# ╔═╡ f661e0a7-9a4c-4a78-8a88-15a644e2a0eb
begin
	om=o.minimizer
	EDOoptima=ODEProblem(modelo,h₀,tspan,om)
	hEDOoptima=solve(EDOoptima)
	plot(hEDOoptima,lw=5,label="EDO optima")
	scatter!(tiempo₁,h1₁,label="Altura",lw=4, xlabel = "Tiempo",yaxis="Altura",legend=:bottomright)
end

# ╔═╡ 800bba01-6fa7-47f9-a47b-56ab17c7ae9f
md"""Ya conociendo al EDO y su solución podemos predecir la altura futura del líquido, por ejemplo la altura que nos da este modelo para $t=2m=120s$ es de:"""

# ╔═╡ d4f3b693-084e-43fa-bf0e-0f969817d49d
hEDOoptima(120)

# ╔═╡ 3c8d293b-9783-4d38-880b-6cc5d014e4bd
md"""En el modelo 1 vimos que dicha predicción de la altura del líquido pasados los 2 minutos fue de 2.97cm y ahora con el modelo 2 obtuvimos que es 2.17cm, según se observa en el video [1] la altura es de 2.2 cm. De esto se observa que el modelo 2 es más preciso."""

# ╔═╡ cec7f6bf-d65c-464a-8721-b25104d391b7
md"""
#### Estimación de parámetros por medio de inferencia bayesiana
"""

# ╔═╡ 5d88f1ad-ba91-4ad6-8811-f1bf9b13c252
md"""
Creamos las funciones adecuadas para ejecutar el algoritmo MHRW. 
"""

# ╔═╡ a7a939db-e19d-4cec-8bd7-4bdcb348b569
begin
	function H1₂(par)
		#Modelo
		EDO=ODEProblem(modelo,h₀,tspan,par)
	  	hSOL=solve(EDO)
	  	hI=[hSOL(t) for t in tiempo₁]
		return hI
	end
	
	function soporte12(par)
		#Intervalos en donde varían los parámetros
		if -8<=par[1]<=8 && -5<=par[2]<=5
			return true
		else
			return false
		end
	end

	function logenergiaH12(par)
		#Función de energía de los parámetros
		mu = H1₂(par)
		log_likelihood = sum(logpdf.(Normal.(mu,1), h1₁))
		log_prior = logpdf(Normal(5,1), par[1]) + logpdf(Normal(1,1), par[2])
		return log_likelihood + 0.1*log_prior - 0.1*(par[1]^2+par[2]^2)^0.5
	end
end

# ╔═╡ 27d4e0af-4ef1-49ca-917a-5f1430045d51
md"""
En este caso estamos suponiendo que los datos se comportan con distribución normal con media $\mu=H1_2(t;\alpha,\epsilon)$ y varianza $\sigma^2 = 1$. Además para solucionar problemas de falta de "buen comportamiento" de los datos le añadimos una penalización de la norma euclidiana de los parámetros, esto se hace con el fin de que la función de log-energía tenga un máximo al cual el algoritmo MHRW pueda converger. Para los parámetros suponemos que a priori $\alpha\sim Normal(5,1)$ y $\epsilon\sim Normal(1,1)$ basado en el conocimiento de los parámetros que obtuvimos con la optimización.

Como se puede evidenciar la función de log-energía alcanza un máximo en alguna parte del soporte de los parámetros.
"""

# ╔═╡ 96585ce4-4f13-45cc-8e2d-a4d93d0c56eb
begin
	f(x, y) = logenergiaH12((x,y))
	x_range = 0:0.1:7
	y_range = 0:0.1:7
	mesh_x = zeros(length(x_range), length(y_range))
	mesh_y = zeros(length(x_range), length(y_range))
	for i in 1:length(x_range)
	    for j in 1:length(y_range)
	        mesh_x[i, j] = x_range[i]
	        mesh_y[i, j] = y_range[j]
	    end
	end
	z_values = f.(mesh_x, mesh_y)
	contour(x_range, y_range, z_values, levels=400, color=:viridis, xlabel="epsilon", ylabel="alpha", title="Contornos de energía")
end

# ╔═╡ 5489794f-1b94-4a0b-b9d2-3b626729b1bc
r2 = MHRW0(2,logenergiaH12,soporte12,[1,1])

# ╔═╡ 332821ca-af0f-4005-8882-56ee8db8fd3b
md"""
Los valores de máximo a posteriori y de media condicional para ambos parámetros son:
"""

# ╔═╡ 07771bf1-a370-408b-b567-4dbb88357c30
begin
	println("Máximo a posteriori: ",r2[1])
	println("Media condicional: ", r2[3])
end

# ╔═╡ 4da35556-8b51-4cb2-bd01-1bdb6aa9bd41
md"""
La distribución de cada uno de los parámetros se muestra a continuación.
"""

# ╔═╡ 92ffd149-8d5f-4ad2-b7a6-f2722aeb91bc
begin
	plot12h = histogram(r2[4][1,:],bins=50,label="Distribución de alpha")
	plot12h = plot!([r2[1][1],r2[1][1]],[0,100],label="MAP",lw=4)
	plot12h = plot!([r2[3][1,1],r2[3][1,1]],[0,100],label="CM",lw=4)
	
	plot120 = histogram(r2[4][2,:],bins=50,label="Distribución de epsilon")
	plot120 = plot!([r2[1][2],r2[1][2]],[0,100],label="MAP",lw=4)
	plot120 = plot!([r2[3][2,1],r2[3][2,1]],[0,100],label="CM",lw=4)
	
	plot(plot12h,plot120,layout=(1,2),size=(900,400))
end

# ╔═╡ 678c9022-34b1-48c5-9d03-571ef4c35e89
md"""
El ajuste de los parámetros se muestra en el siguiente gráfico. Note que en este caso la variabilidad del modelo es baja puesto que las muestras(mostrado por las gráficas grises) de cada uno de los parámetros están "cerca" a los datos. Además, los valores del máximo a posteriori y de la media condicional son demasiado cercanos, esto significa que los datos se ajustan de manera óptima al modelo.
"""

# ╔═╡ 80895e7e-e8f0-4d81-89a7-0dc3b88c60fe
begin
	plot12 = plot(tiempo₁,H1₂(r2[4][:,1]),color="gray82",label=false,z=1)
	for i in 1:10:length(r2[4][1,:])
		plot12 = plot!(tiempo₁,H1₂(r2[4][:,i]),color="gray82",label=false,z=1)
	end
	plot12 = scatter!(tiempo₁,h1₁,label="Altura",lw=4, xlabel = "Tiempo",yaxis="Altura",legend=:bottomright)
	plot12 = plot!(tiempo₁,H1₂(r2[1]),label="MAP",lw=3)
	plot12 = plot!(tiempo₁,H1₂(r2[3]),label="CM",lw=3)
	plot(plot12)
end

# ╔═╡ fa1ac74e-bb62-4366-b58e-3d0de0f489f4
md"""## Tanque 2

Los datos recopilados del experimento del video [2] son los siguientes:"""

# ╔═╡ 83e4e0a7-8e09-4f7e-aa79-57d47526e68d
tiempo₃ = [19+4*i for i in 1:25] #instantes de tiempo (medidos en segundos)

# ╔═╡ a2e2923a-dd73-400a-8771-e26c3290cb81
h1₃ = [12.6, 12.3, 12, 11.8, 11.6, 11.4, 11.2, 10.9, 10.7, 10.5, 10.3, 10.1, 9.9, 9.7, 9.5, 9.3, 9.1, 8.9, 8.7, 8.5, 8.3, 8.2, 8, 7.8, 7.6] #altura del agua en cada instante de tiempo tomado

# ╔═╡ 7bacffab-69ee-43a6-a033-04590cc2148d
md"""Visualicemos dichos datos."""

# ╔═╡ 7d12950b-8813-4165-bd52-49c5880970d5
scatter(tiempo₃,h1₃,ls=:dash,label="Altura h₁",lw=4, xlabel = "Tiempo",yaxis="Altura h₁")

# ╔═╡ 7eab1f4c-af65-4893-bf77-2fb148ed1e69
md"""### Modelo 1: Ley de Torricelli
Ajustaremos los datos a un modelo de ecuaciones diferenciales que ya dedujimos anteriormente

$\frac{dh}{dt}=-\alpha\frac{r_2^2\sqrt{2(g+\epsilon)(h_1-h_2)}}{r_1^2}.$
Recordemos que los parámetros que no conocemos son $\alpha$ y $\epsilon$. Estos serán los que deseamos ajustar. Con la condición inicial $h_{23}=h(23)=12.6$"""

# ╔═╡ 48515007-88fb-494d-9e59-bf7902d021a1
md"""Creamos una función para dicho modelo:"""

# ╔═╡ 3dad3a1f-79c2-4913-8151-f0dfdf229285
modelo₃(h₃,par₃,t₃)=-par₃[1]*(0.099219/4.17)^2*(2*(g+par₃[2]))^(1/2)*abs(h₃-0.5).^(1/2)

# ╔═╡ 7b8f031b-1afa-4e5f-a33a-980f90b65c1f
md"""
Si queremos resolver la EDO para determinados valorres de los parámetros, usamos, 
"""

# ╔═╡ 99ef4432-99e6-4e4f-97b8-22e0b6e9249a
begin
	tspan₃=(23,240)
	h₀₃=12.6
	par₃=[1.0, 1.0]
	EDO₃=ODEProblem(modelo₃,h₀₃,tspan₃,par₃)
	h₃=solve(EDO₃)
	plot(h₃)
end

# ╔═╡ dc6247e4-4fd5-4630-b68f-273dc0c0f314
md"""
#### Estimación de parámetros por medio de optimización
"""

# ╔═╡ f9de5b2c-5c50-46bb-8461-7359354672f4
md"""
Al igual que en los ejemplos anteriores, podemos escribir la función residuo del modelo de la EDO.
"""

# ╔═╡ 97068776-f732-492d-9501-5223d99b85ba
function residuo₃(par,h,t)
  tspan=(23,240)
  h₀=11.8
  EDO=ODEProblem(modelo₃,h₀,tspan,par)
  hSOL=solve(EDO)
  hI=[hSOL(t) for t in tiempo₃]
  res=h-hI
  nres=norm(res)
return nres
end

# ╔═╡ a1003919-4324-43ef-afa6-49d1e7d092d5
md"""La función residuo arriba mide el desajuste (o tamaño del residuo) de la simulación de la EDO con respecto a los datos usando mínimos cuadrados, es decir, la norma euclidiana de la diferencia o residuo. 

Por ejemplo, el desajuste de usar $\alpha=1$ y $\epsilon=1$ en el modelo es de:"""

# ╔═╡ 19110a58-1bae-43d2-8398-3bf7b9d9e7e5
residuo₃([1 1],h1₃,tiempo₃)

# ╔═╡ a4dda2e3-a5b9-406b-af0d-40b9ec6133de
md"""
Observe que este valor es considerablemente grande, por lo tanto, es crucial encontrar el valor óptimo.
"""

# ╔═╡ 9fd9234c-4ae2-4fa4-8818-fabe8c760e5c
r₃(par₃) = residuo₃(par₃,h1₃,tiempo₃)

# ╔═╡ 9994161e-4951-4760-bb2e-6256e78ef02d
md"""
Ahora, optimicemos el valor de los parámetros, de la siguiente forma:
"""

# ╔═╡ 68a0c0ed-aa53-4223-8541-e5969a3f5562
o₃=Optim.optimize(r₃, [.01,.01], NelderMead())

# ╔═╡ ad9abed3-6efd-4ea1-8958-b1660503fb2b
o₃.minimizer

# ╔═╡ 48557bcc-6852-4081-85d9-c7bf94674aee
md"""Obteniendo así que los valores optimos para $\alpha$ y $\epsilon$ son $5.0699$ y $1.0067$, respectivamente. 

Así la ecuación diferencial que se ajusta a nuestros datos es

$\frac{dh}{dt}=-5.0699\frac{r_2^2\sqrt{2(g+1.0067)(h_1-h_2)}}{r_1^2}.$
Después de calcular el valor del parámetro óptimo podemos mostrar el ajuste final de nuestro modelo. """

# ╔═╡ 69ff1996-4f6e-49a1-811d-24cd3caa8c84
begin
	om₃=o₃.minimizer
	EDOoptima₃=ODEProblem(modelo₃,h₀₃,tspan₃,om₃)
	hEDOoptima₃=solve(EDOoptima₃)
	plot(hEDOoptima₃,lw=5,label="EDO optima")
	scatter!(tiempo₃,h1₃,label="Altura",lw=4, xlabel = "Tiempo",yaxis="Altura",legend=:bottomright)
end

# ╔═╡ 2c37107e-7114-42a7-a538-797ab4bec8b9
md"""Ya conociendo al EDO y su solución podemos predecir la altura del líquido luego  de 4 minutos, observe que este es de"""

# ╔═╡ a28a4d79-c9db-4792-98bb-39c6418abf3b
hEDOoptima₃(240)

# ╔═╡ 0f2e88e1-ba63-446e-8f78-03d899e1df05
md"""Según se observa en el video la altura del líquido al pasar 4 minutos es de 3.4cm, por tanto el modelo no es tan preciso."""

# ╔═╡ f25dad77-e5d6-4516-ab1b-2ff6a8c3cb8c
md"""
#### Estimación de parámetros por medio de inferencia bayesiana
"""

# ╔═╡ 9f10e79c-ecaa-4851-94d9-c26e0d5cc9a2
begin
	function H2(par)
		#Modelo
		EDO=ODEProblem(modelo₃,h₀₃,tspan₃,par)
	  	hSOL=solve(EDO)
	  	hI=[hSOL(t) for t in tiempo₃]
		return hI
	end
	
	function soporte2(par)
		# Soporte de los parámetros
		if -8<=par[1]<=8 && -5<=par[2]<=5
			return true
		else
			return false
		end
	end

	function logenergiaH2(par)
		#Función de log-energía de los parámetros
		mu = H2(par)
		log_likelihood = sum(logpdf.(Normal.(mu,1), h1₃))
		log_prior = logpdf(Normal(6,1), par[1]) + logpdf(Normal(1,1), par[2])
		return log_likelihood + log_prior
	end
end

# ╔═╡ b304b42f-47a7-468f-b045-8d0f70c039ca
md"""
En este caso suponemos que los datos vienen de una distribución con media $\mu$ igual al modelo dado por la ley de Torricelli y con varianza $\sigma^2=1$. Para los parámetros asumimos que $\alpha\sim Normal(6,1)$ y $\epsilon\sim Normal(1,1)$. Como lo sugiere el gráfico a continuación, la energía alcanza un máximo.
"""

# ╔═╡ 9716805e-4358-4ddd-879e-317c5ce3a477
begin
	f2(x, y) = logenergiaH2((x,y))
	x_range2 = 0:0.05:8
	y_range2 = 0:0.05:8
	mesh_x2 = zeros(length(x_range2), length(y_range2))
	mesh_y2 = zeros(length(x_range2), length(y_range2))
	for i in 1:length(x_range2)
	    for j in 1:length(y_range2)
	        mesh_x2[i, j] = x_range2[i]
	        mesh_y2[i, j] = y_range2[j]
	    end
	end
	z_values2 = f2.(mesh_x2, mesh_y2)
	contour(x_range2, y_range2, z_values2, levels=250, color=:viridis, xlabel="epsilon", ylabel="alpha", title="Contornos de energía")
end

# ╔═╡ 459fd343-55fc-4314-82e3-4d34ed301337
md"""
Ejecutamos el algoritmo.
"""

# ╔═╡ a58b37ce-6abe-45b9-95a3-23debbce228e
r3 = MHRW0(2,logenergiaH2,soporte2,[1,1])

# ╔═╡ 42e5d3d0-084e-4112-8b0d-2c52f0778780
md"""
Los valores obtenidos para los parámetros en cada una de las dos estadísticas son:
"""

# ╔═╡ 9d247ff1-3776-47cd-a067-88d72e6ac82e
begin
	println("Máximo a posteriori: ",r3[1])
	println("Media condicional: ", r3[3])
end

# ╔═╡ df76f922-6f95-425a-a07f-78cf94be87ad
md"""
En los gráficos siguientes mostramos la distribución de cada uno de los parámetros y el ajuste del máximo a posteriori, la media condicional y las muestras a los datos en este caso. Nótese que el parámetro $\alpha$ concentra la mayoría de sus valores alrededor de ambas estadísticas, contrario al parámetro $\epsilon$ que presenta una mayor variabilidad. 
"""

# ╔═╡ e12f6e11-d1ce-4543-ae8a-6109a6138526
begin
	plot2h = histogram(r3[4][1,:],bins=50,label="Distribución de alpha")
	plot2h = plot!([r3[1][1],r3[1][1]],[0,100],label="MAP",lw=4)
	plot2h = plot!([r3[3][1,1],r3[3][1,1]],[0,100],label="CM",lw=4)
	
	plot20 = histogram(r3[4][2,:],bins=50,label="Distribución de epsilon")
	plot20 = plot!([r3[1][2],r3[1][2]],[0,100],label="MAP",lw=4)
	plot20 = plot!([r3[3][2,1],r3[3][2,1]],[0,100],label="CM",lw=4)
	
	plot(plot2h,plot20,layout=(1,2),size=(900,400))
end

# ╔═╡ 110c3b10-2364-46a9-82fe-d04667d80b86
begin
	plot2 = plot(tiempo₃,H2(r3[4][:,1]),color="gray82",label="Muestras",z=1)
	for i in 1:2:length(r3[4][1,:])
		plot12 = plot!(tiempo₃,H2(r3[4][:,i]),color="gray82",label=false,z=1)
	end
	plot2 = plot!(tiempo₃,H2(r3[1]),label="MAP",lw=3)
	plot2 = plot!(tiempo₃,H2(r3[3]),label="CM",lw=3)
	plot2 = scatter!(tiempo₃,h1₃,label="Altura",lw=4, xlabel = "Tiempo",yaxis="Altura",legend=:bottomright)
	plot(plot2)
end

# ╔═╡ cf1b1b8b-8cde-4fb7-9705-dadca70d2e4f
md"""# Referencias

[1] SIMIODE. (2014, Mayo 31). SIMIODE Torricelli's Law 7Over64 Inch Diameter Small Hole Collection Video [Video]. YouTube. https://www.youtube.com/watch?v=xDyDSPydN_E

[2] SIMIODE. (2014, Mayo 31). SIMIODE Torricelli's Law 5Over64 Inch Diameter Small Hole Collection Video [Video]. YouTube. https://www.youtube.com/watch?v=CZvTGLzJI_A

[3] Boyce, W. E., & DiPrima, R. C. (2004). Elementary Differential Equations (8a ed.). Nueva York: John Wiley and Sons.

[4] Bryan, K. (2021). Differential Equations: A Toolbox to Modeling the World. SIMIODE.

[5] Driscoll, T. A., & Braun, R. J. (Year). Fundamentals of Numerical Computation. Retrieved from https://tobydriscoll.net/fnc-julia/frontmatter.html

[6] Sullivan, E. (2020). Numerical Methods: An Inquiry-Based Approach With Python.

[7] Bulirsch, R., Stoer, J., & Stoer, J. (2002). Introduction to Numerical Analysis (Vol. 3). Heidelberg: Springer.

[8] Stewart, G. W. (1996). Afternotes on Numerical Analysis. Society for Industrial and Applied Mathematics.

[9] Quarteroni, A., Saleri, F., & Gervasio, P. (2006). Scientific Computing with MATLAB and Octave (Vol. 3). Berlin: Springer.

[10] Last name, Initials. (Year). Machine Learning and Data Mining [Lecture Notes]. Retrieved from http://www.dgp.toronto.edu/~hertzman/411notes.pdf

[11] Last name, Initials. (Year). Deep Learning [Lecture Slides]. Retrieved from https://www.deeplearningbook.org/lecture_slides.html

[12] Mayorga, A. J. H. (2004). Inferencia estadística. Universidad Nacional de Colombia.

[13] Blanco Castañeda, L. (2004). Probabilidad. Universidad Nacional de Colombia.

[14] Kaipio, J., & Somesalo, E. (2004). Statistical and Computational Inverse Problems. Springer.

[15] Häggström, O. (2002). Finite Markov Chains and Algorithmic Applications. Cambridge University Press."""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Optim = "429524aa-4258-5aef-a3af-852621145aeb"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[compat]
DifferentialEquations = "~7.10.0"
Distributions = "~0.25.107"
Optim = "~1.9.2"
Plots = "~1.39.0"
PlutoUI = "~0.7.58"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.3"
manifest_format = "2.0"
project_hash = "00f37f137b9962a24e502f0dc0c6b547f0bb3320"

[[deps.ADTypes]]
git-tree-sha1 = "016833eb52ba2d6bea9fcb50ca295980e728ee24"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "0.2.7"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cde29ddf7e5726c9fb511f340244ea3481267608"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["Random"]
git-tree-sha1 = "07591db28451b3e45f4c0088a2d5e986ae5aa92d"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.1"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "c5aeb516a84459e0318a02507d2261edad97eb75"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.7.1"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra"]
git-tree-sha1 = "33207a8be6267bc389d0701e97a9bce6a4de68eb"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "1.9.2"
weakdeps = ["SparseArrays"]

    [deps.ArrayLayouts.extensions]
    ArrayLayoutsSparseArraysExt = "SparseArrays"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "PrecompileTools"]
git-tree-sha1 = "0b816941273b5b162be122a6c94d706e3b3125ca"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "0.17.38"
weakdeps = ["SparseArrays"]

    [deps.BandedMatrices.extensions]
    BandedMatricesSparseArraysExt = "SparseArrays"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "0c5f81f47bbbcf4aea7b2959135713459170798b"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.5"

[[deps.BoundaryValueDiffEq]]
deps = ["ArrayInterface", "BandedMatrices", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "NonlinearSolve", "Reexport", "SciMLBase", "Setfield", "SparseArrays", "TruncatedStacktraces", "UnPack"]
git-tree-sha1 = "f7392ce20e6dafa8fee406142b1764de7d7cd911"
uuid = "764a87c0-6b3e-53db-9096-fe964310641d"
version = "4.0.1"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "601f7e7b3d36f18790e2caf83a882d88e9b71ff1"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.4"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a4c43f59baa34011e303e76f5c8c91bf58415aaf"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "575cd02e080939a33b6df6c5853d14924c08e35b"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.23.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "70232f82ffaab9dc52585e0dd043b5e0c6b714f1"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.12"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "c955881e3c981181362ae4088b35995446298b80"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.14.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ConcreteStructs]]
git-tree-sha1 = "f749037478283d372048690eb3b5f92a79432b34"
uuid = "2569d6c7-a4a2-43d3-a901-331e8e4be471"
version = "0.2.3"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "6cbbd4d241d7e6579ab354737f4dd95ca43946e1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.1"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "260fd2400ed2dab602a7c15cf10c1933c59930a2"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.5"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelayDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "LinearAlgebra", "Logging", "OrdinaryDiffEq", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "SimpleNonlinearSolve", "SimpleUnPack"]
git-tree-sha1 = "e40378efd2af7658d0a0579aa9e15b17137368f4"
uuid = "bcd4f6db-9728-5f36-b5f7-82caef46ccdb"
version = "5.44.0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DiffEqBase]]
deps = ["ArrayInterface", "ChainRulesCore", "DataStructures", "DocStringExtensions", "EnumX", "FastBroadcast", "ForwardDiff", "FunctionWrappers", "FunctionWrappersWrappers", "LinearAlgebra", "Logging", "Markdown", "MuladdMacro", "Parameters", "PreallocationTools", "PrecompileTools", "Printf", "RecursiveArrayTools", "Reexport", "Requires", "SciMLBase", "SciMLOperators", "Setfield", "SparseArrays", "Static", "StaticArraysCore", "Statistics", "Tricks", "TruncatedStacktraces", "ZygoteRules"]
git-tree-sha1 = "0d9982e8dee851d519145857e79a17ee33ede154"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.130.0"

    [deps.DiffEqBase.extensions]
    DiffEqBaseDistributionsExt = "Distributions"
    DiffEqBaseGeneralizedGeneratedExt = "GeneralizedGenerated"
    DiffEqBaseMPIExt = "MPI"
    DiffEqBaseMeasurementsExt = "Measurements"
    DiffEqBaseMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    DiffEqBaseReverseDiffExt = "ReverseDiff"
    DiffEqBaseTrackerExt = "Tracker"
    DiffEqBaseUnitfulExt = "Unitful"
    DiffEqBaseZygoteExt = "Zygote"

    [deps.DiffEqBase.weakdeps]
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    GeneralizedGenerated = "6b9d7cbe-bcb9-11e9-073f-15a7a543e2eb"
    MPI = "da04e1cc-30fd-572f-bb4f-1f8673147195"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.DiffEqCallbacks]]
deps = ["DataStructures", "DiffEqBase", "ForwardDiff", "Functors", "LinearAlgebra", "Markdown", "NLsolve", "Parameters", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArraysCore"]
git-tree-sha1 = "d0b94b3694d55e7eedeee918e7daee9e3b873399"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "2.35.0"
weakdeps = ["OrdinaryDiffEq", "Sundials"]

[[deps.DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "GPUArraysCore", "LinearAlgebra", "Markdown", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "Requires", "ResettableStacks", "SciMLBase", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "65cbbe1450ced323b4b17228ccd96349d96795a7"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.21.0"

    [deps.DiffEqNoiseProcess.extensions]
    DiffEqNoiseProcessReverseDiffExt = "ReverseDiff"

    [deps.DiffEqNoiseProcess.weakdeps]
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.DifferentialEquations]]
deps = ["BoundaryValueDiffEq", "DelayDiffEq", "DiffEqBase", "DiffEqCallbacks", "DiffEqNoiseProcess", "JumpProcesses", "LinearAlgebra", "LinearSolve", "NonlinearSolve", "OrdinaryDiffEq", "Random", "RecursiveArrayTools", "Reexport", "SciMLBase", "SteadyStateDiffEq", "StochasticDiffEq", "Sundials"]
git-tree-sha1 = "96a19f498504e4a3b39524196b73eb60ccef30e9"
uuid = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
version = "7.10.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "22c595ca4146c07b16bcf9c8bea86f731f7109d2"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.108"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.EnzymeCore]]
git-tree-sha1 = "1bc328eec34ffd80357f84a84bb30e4374e9bd60"
uuid = "f151be2c-9106-41f4-ab19-57ee4f262869"
version = "0.6.6"
weakdeps = ["Adapt"]

    [deps.EnzymeCore.extensions]
    AdaptExt = "Adapt"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c6317308b9dc757616f0b5cb379db10494443a7"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.2+0"

[[deps.ExponentialUtilities]]
deps = ["Adapt", "ArrayInterface", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "PrecompileTools", "Printf", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "8e18940a5ba7f4ddb41fe2b79b6acaac50880a86"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.26.1"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FastBroadcast]]
deps = ["ArrayInterface", "LinearAlgebra", "Polyester", "Static", "StaticArrayInterface", "StrideArraysCore"]
git-tree-sha1 = "a6e756a880fc419c8b41592010aebe6a5ce09136"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.2.8"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FastLapackInterface]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f4102aab9c7df8691ed09f9c42e34f5ab5458ab9"
uuid = "29a986be-02c6-4525-aec4-84b980013641"
version = "2.0.3"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "57f08d5665e76397e96b168f9acc12ab17c84a68"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.10.2"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays"]
git-tree-sha1 = "2de436b72c3422940cbe1367611d137008af7ec3"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.23.1"

    [deps.FiniteDiff.extensions]
    FiniteDiffBandedMatricesExt = "BandedMatrices"
    FiniteDiffBlockBandedMatricesExt = "BlockBandedMatrices"
    FiniteDiffStaticArraysExt = "StaticArrays"

    [deps.FiniteDiff.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "db16beca600632c95fc8aca29890d83788dd8b23"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.96+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1ed150b39aebcc805c26b93a8d0122c940f64ce2"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.14+0"

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "b104d487b34566608f8b4e1c39fb0b10aa279ff8"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.3"

[[deps.Functors]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d3e63d9fa13f8eaa2f06f64949e2afc593ff52c2"
uuid = "d9f16b24-f501-4c13-a1f2-28368ffc5196"
version = "0.4.10"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "ff38ba61beff76b8f4acad8ab0c97ef73bb670cb"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.9+0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "27442171f28c952804dede8ff72828a96f2bfc1f"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.10"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "025d171a2847f616becc0f84c8dc62fe18f0f6dd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.10+0"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "af49a0851f8113fcfae2ef5027c6d49d0acec39b"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.4"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "359a1ba2e320790ddbe4ee8b4d54a305c0ea2aff"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.0+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "3863330da5466410782f2bffc64f3d505a6a8334"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.10.0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "2c3ec1f90bb4a8f7beafb0cffea8a4c3f4e636ab"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.6"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "eb8fed28f4994600e29beef49744639d985a04b2"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.16"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.Inflate]]
git-tree-sha1 = "ea8031dea4aff6bd41f1df8f2fdfb25b33626381"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.4"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be50fe8df3acbffa0274a744f1a99d29c45a57f4"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.1.0+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3336abae9a713d2210bb57ab484b1e065edd7d23"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.2+0"

[[deps.JumpProcesses]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "FunctionWrappers", "Graphs", "LinearAlgebra", "Markdown", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "StaticArrays", "UnPack"]
git-tree-sha1 = "c451feb97251965a9fe40bacd62551a72cc5902c"
uuid = "ccbc3e58-028d-4f4c-8cd5-9ae44345cda5"
version = "9.10.1"
weakdeps = ["FastBroadcast"]

    [deps.JumpProcesses.extensions]
    JumpProcessFastBroadcastExt = "FastBroadcast"

[[deps.KLU]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse_jll"]
git-tree-sha1 = "884c2968c2e8e7e6bf5956af88cb46aa745c854b"
uuid = "ef3ab10e-7fda-4108-b977-705223b18434"
version = "0.4.1"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "267dad6b4b7b5d529c76d40ff48d33f7e94cb834"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.9.6"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "70c5da094887fd2cae843b8db33920bac4b6f07d"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "e0b5cd21dc1b44ec6e64f351976f961e6f31d6c4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.3"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "62edfee3211981241b57ff1cedf4d74d79519277"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.15"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LevyArea]]
deps = ["LinearAlgebra", "Random", "SpecialFunctions"]
git-tree-sha1 = "56513a09b8e0ae6485f34401ea9e2f31357958ec"
uuid = "2d8b4e74-eb68-11e8-0fb9-d5eb67b50637"
version = "1.0.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "9fd170c4bbfd8b935fdc5f8b7aa33532c991a673"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.11+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fbb1f2bef882392312feb1ede3615ddc1e9b99ed"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.49.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4b683b19157282f50bfd5dcaa2efe5295814ea22"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "27fd5cc10be85658cacfe11bb81bee216af13eda"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.0+0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearSolve]]
deps = ["ArrayInterface", "ConcreteStructs", "DocStringExtensions", "EnumX", "EnzymeCore", "FastLapackInterface", "GPUArraysCore", "InteractiveUtils", "KLU", "Krylov", "Libdl", "LinearAlgebra", "MKL_jll", "PrecompileTools", "Preferences", "RecursiveFactorization", "Reexport", "Requires", "SciMLBase", "SciMLOperators", "Setfield", "SparseArrays", "Sparspak", "SuiteSparse", "UnPack"]
git-tree-sha1 = "9f27ba34f5821a0495efb09ea3a465c31326495a"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "2.10.0"

    [deps.LinearSolve.extensions]
    LinearSolveBlockDiagonalsExt = "BlockDiagonals"
    LinearSolveCUDAExt = "CUDA"
    LinearSolveEnzymeExt = "Enzyme"
    LinearSolveHYPREExt = "HYPRE"
    LinearSolveIterativeSolversExt = "IterativeSolvers"
    LinearSolveKernelAbstractionsExt = "KernelAbstractions"
    LinearSolveKrylovKitExt = "KrylovKit"
    LinearSolveMetalExt = "Metal"
    LinearSolvePardisoExt = "Pardiso"

    [deps.LinearSolve.weakdeps]
    BlockDiagonals = "0a1fb500-61f7-11e9-3c65-f5ef3456f9f0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    HYPRE = "b5ffcf37-a2bd-41ab-a3da-4bd9bc8ad771"
    IterativeSolvers = "42fd0dbc-a981-5370-80f2-aaf504508153"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    KrylovKit = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
    Metal = "dde4c033-4e86-420c-a63e-0dd931031962"
    Pardiso = "46dd5b70-b6fb-5a00-ae2d-e8fea33afaf2"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "18144f3e9cbe9b15b070288eef858f71b291ce37"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.27"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "8f6786d8b2b3248d79db3ad359ce95382d5a6df8"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.170"
weakdeps = ["ChainRulesCore", "ForwardDiff", "SpecialFunctions"]

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "80b2833b56d466b3858d565adcd16a4a05f2089b"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.1.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.MuladdMacro]]
git-tree-sha1 = "cac9cc5499c25554cba55cd3c30543cff5ca4fab"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.4"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.NonlinearSolve]]
deps = ["ArrayInterface", "DiffEqBase", "EnumX", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "LinearSolve", "PrecompileTools", "RecursiveArrayTools", "Reexport", "SciMLBase", "SimpleNonlinearSolve", "SparseArrays", "SparseDiffTools", "StaticArraysCore", "UnPack"]
git-tree-sha1 = "e10debcea868cd6e51249e8eeaf191c25f68a640"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "1.10.1"

[[deps.OffsetArrays]]
git-tree-sha1 = "e64b4f5ea6b7389f6f046d13d4896a8f9c1ba71e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3da7367955dcc5c54c1ba4d402ccdc09a1a3e046"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+1"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "d9b79c4eed437421ac4285148fcadf42e0700e89"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.9.4"

    [deps.Optim.extensions]
    OptimMOIExt = "MathOptInterface"

    [deps.Optim.weakdeps]
    MathOptInterface = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.OrdinaryDiffEq]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "ExponentialUtilities", "FastBroadcast", "FastClosures", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "IfElse", "InteractiveUtils", "LineSearches", "LinearAlgebra", "LinearSolve", "Logging", "LoopVectorization", "MacroTools", "MuladdMacro", "NLsolve", "NonlinearSolve", "Polyester", "PreallocationTools", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLNLSolve", "SciMLOperators", "SimpleNonlinearSolve", "SimpleUnPack", "SparseArrays", "SparseDiffTools", "StaticArrayInterface", "StaticArrays", "TruncatedStacktraces"]
git-tree-sha1 = "f0f43037c0ba045e96f32d65858eb825a211b817"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.58.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.PackageExtensionCompat]]
git-tree-sha1 = "fb28e33b8a95c4cee25ce296c817d89cc2e53518"
uuid = "65ce6f38-6b18-4e1d-a461-8949797d7930"
version = "1.0.2"
weakdeps = ["Requires", "TOML"]

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "7b1a9df27f072ac4c9c7cbe5efb198489258d1f5"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "ccee59c6e48e6f2edf8a5b64dc817b6729f99eb5"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.39.0"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

[[deps.PoissonRandom]]
deps = ["Random"]
git-tree-sha1 = "a0f1159c33f846aa77c3f30ebbc69795e5327152"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.4"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Requires", "Static", "StaticArrayInterface", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "2ba5f33cbb51a85ef58a850749492b08f9bf2193"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.7.13"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "240d7170f5ffdb285f9427b92333c3463bf65bf6"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.1"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "ForwardDiff"]
git-tree-sha1 = "a660e9daab5db07adf3dedfe09b435cc530d855e"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.21"

    [deps.PreallocationTools.extensions]
    PreallocationToolsReverseDiffExt = "ReverseDiff"

    [deps.PreallocationTools.weakdeps]
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9b23c31e76e333e6fb4c1595ae6afa74966a729e"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "4743b43e5a9c4a2ede372de7061eed81795b12e7"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.7.0"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "Requires", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables"]
git-tree-sha1 = "d7087c013e8a496ff396bae843b1e16d9a30ede8"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.38.10"

    [deps.RecursiveArrayTools.extensions]
    RecursiveArrayToolsMeasurementsExt = "Measurements"
    RecursiveArrayToolsMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    RecursiveArrayToolsTrackerExt = "Tracker"
    RecursiveArrayToolsZygoteExt = "Zygote"

    [deps.RecursiveArrayTools.weakdeps]
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "PrecompileTools", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "6db1a75507051bc18bfa131fbc7c3f169cc4b2f6"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.23"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "04c968137612c4a5629fa531334bb81ad5680f00"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.13"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "3aac6d68c5e57449f5b9b865c9ba50ac2970c4cf"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.42"

[[deps.SciMLBase]]
deps = ["ADTypes", "ArrayInterface", "ChainRulesCore", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "FillArrays", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "PrecompileTools", "Preferences", "RecipesBase", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLOperators", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables", "TruncatedStacktraces", "ZygoteRules"]
git-tree-sha1 = "916b8a94c0d61fa5f7c5295649d3746afb866aff"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.98.1"

    [deps.SciMLBase.extensions]
    ZygoteExt = "Zygote"

    [deps.SciMLBase.weakdeps]
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.SciMLNLSolve]]
deps = ["DiffEqBase", "LineSearches", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "765b788339abd7d983618c09cfc0192e2b6b15fd"
uuid = "e9a6253c-8580-4d32-9898-8661bb511710"
version = "0.1.9"

[[deps.SciMLOperators]]
deps = ["ArrayInterface", "DocStringExtensions", "LinearAlgebra", "MacroTools", "Setfield", "SparseArrays", "StaticArraysCore"]
git-tree-sha1 = "10499f619ef6e890f3f4a38914481cc868689cd5"
uuid = "c0aeaf25-5076-4817-a8d5-81caf7dfa961"
version = "0.3.8"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleNonlinearSolve]]
deps = ["ArrayInterface", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "PackageExtensionCompat", "PrecompileTools", "Reexport", "SciMLBase", "StaticArraysCore"]
git-tree-sha1 = "15ff97fa4881133caa324dacafe28b5ac47ad8a2"
uuid = "727e6d20-b764-4bd8-a329-72de5adea6c7"
version = "0.1.23"

    [deps.SimpleNonlinearSolve.extensions]
    SimpleNonlinearSolveNNlibExt = "NNlib"

    [deps.SimpleNonlinearSolve.weakdeps]
    NNlib = "872c559c-99b0-510c-b3b7-b6c96a88d5cd"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleUnPack]]
git-tree-sha1 = "58e6353e72cde29b90a69527e56df1b5c3d8c437"
uuid = "ce78b400-467f-4804-87d8-8f486da07d0a"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SparseDiffTools]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "PackageExtensionCompat", "Random", "Reexport", "SciMLOperators", "Setfield", "SparseArrays", "StaticArrayInterface", "StaticArrays", "Tricks", "UnPack", "VertexSafeGraphs"]
git-tree-sha1 = "cce98ad7c896e52bb0eded174f02fc2a29c38477"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "2.18.0"

    [deps.SparseDiffTools.extensions]
    SparseDiffToolsEnzymeExt = "Enzyme"
    SparseDiffToolsPolyesterExt = "Polyester"
    SparseDiffToolsPolyesterForwardDiffExt = "PolyesterForwardDiff"
    SparseDiffToolsSymbolicsExt = "Symbolics"
    SparseDiffToolsZygoteExt = "Zygote"

    [deps.SparseDiffTools.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    Polyester = "f517fe37-dbe3-4b94-8317-1923a5111588"
    PolyesterForwardDiff = "98d1487c-24ca-40b6-b7ab-df2af84e126b"
    Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.Sparspak]]
deps = ["Libdl", "LinearAlgebra", "Logging", "OffsetArrays", "Printf", "SparseArrays", "Test"]
git-tree-sha1 = "342cf4b449c299d8d1ceaf00b7a49f4fbc7940e7"
uuid = "e56a9233-b9d6-4f03-8d0f-1825330902ac"
version = "0.3.9"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "d2fdac9ff3906e27f7a618d47b676941baa6c80c"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.8.10"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Requires", "SparseArrays", "Static", "SuiteSparse"]
git-tree-sha1 = "5d66818a39bb04bf328e92bc933ec5b4ee88e436"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.5.0"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "bf074c045d3d5ffd956fa0a461da38a44685d6b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.3"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "cef0472124fab0695b58ca35a77c6fb942fdab8a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.1"

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.SteadyStateDiffEq]]
deps = ["DiffEqBase", "DiffEqCallbacks", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "2ca69f4be3294e4cd987d83d6019037d420d9fc1"
uuid = "9672c7b4-1e72-59bd-8a11-6ac3964bc41f"
version = "1.16.1"

[[deps.StochasticDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqNoiseProcess", "DocStringExtensions", "FillArrays", "FiniteDiff", "ForwardDiff", "JumpProcesses", "LevyArea", "LinearAlgebra", "Logging", "MuladdMacro", "NLsolve", "OrdinaryDiffEq", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "b341540a647b39728b6d64eaeda82178e848f76e"
uuid = "789caeaf-c7a9-5a7d-9973-96adeb23e2a0"
version = "6.62.0"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface", "ThreadingUtilities"]
git-tree-sha1 = "25349bf8f63aa36acbff5e3550a86e9f5b0ef682"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.5.6"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.Sundials]]
deps = ["CEnum", "DataStructures", "DiffEqBase", "Libdl", "LinearAlgebra", "Logging", "PrecompileTools", "Reexport", "SciMLBase", "SparseArrays", "Sundials_jll"]
git-tree-sha1 = "71dc65a2d7decdde5500299c9b04309e0138d1b4"
uuid = "c3572dad-4567-51f8-b174-8c6c989267f4"
version = "4.20.1"

[[deps.Sundials_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "SuiteSparse_jll", "libblastrampoline_jll"]
git-tree-sha1 = "ba4d38faeb62de7ef47155ed321dce40a549c305"
uuid = "fb77eaff-e24c-56d4-86b1-d163f2edb164"
version = "5.2.2+0"

[[deps.SymbolicIndexingInterface]]
deps = ["DocStringExtensions"]
git-tree-sha1 = "f8ab052bfcbdb9b48fad2c80c873aa0d0344dfe5"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.2.2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[deps.TranscodingStreams]]
git-tree-sha1 = "71509f04d045ec714c4748c785a59045c3736349"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.7"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "Static", "VectorizationBase"]
git-tree-sha1 = "66c68a20907800c0b7c04ff8a6164115e8747de2"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.2.0"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.TruncatedStacktraces]]
deps = ["InteractiveUtils", "MacroTools", "Preferences"]
git-tree-sha1 = "ea3e54c2bdde39062abf5a9758a23735558705e1"
uuid = "781d530d-4396-4725-bb49-402e4bee1e77"
version = "1.4.0"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "3c793be6df9dd77a0cf49d80984ef9ff996948fa"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.19.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "6129a4faf6242e7c3581116fbe3270f3ab17c90d"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.67"

[[deps.VertexSafeGraphs]]
deps = ["Graphs"]
git-tree-sha1 = "8351f8d73d7e880bfc042a8b6922684ebeafb35c"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "532e22cf7be8462035d092ff21fada7527e2c488"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.6+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ac88fb95ae6447c8dda6a5503f3bafd496ae8632"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.4.6+0"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "326b4fea307b0b39892b3e85fa451692eda8d46c"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.1+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "3796722887072218eabafb494a13c963209754ce"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d2d1a5c49fae4ba39983f63de6afcbea47194e85"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "47e45cd78224c53109495b3e324df0c37bb61fbe"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+0"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e678132f07ddb5bfa46857f0d7620fb9be675d3b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+0"

[[deps.ZygoteRules]]
deps = ["ChainRulesCore", "MacroTools"]
git-tree-sha1 = "27798139afc0a2afa7b1824c206d5e87ea587a00"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.5"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7d0ea0f4895ef2f5cb83645fa689e52cb55cf493"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2021.12.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─3a89574c-06c9-45b2-8e7e-54a550c26db0
# ╟─920785ba-c91c-4697-84f6-5abdbab026a6
# ╟─24244d99-613e-47fb-b53b-2dc21536a568
# ╟─6815c72f-7456-4756-b228-36bb634157c8
# ╟─622563c7-4137-4af5-82bb-c57e854bfaa0
# ╠═a5d1beba-f053-4c35-a5c9-686c6cc67302
# ╟─19597282-84ea-4bcb-8611-1092535b1b9d
# ╟─89502336-92b1-443b-a74e-519a533f7b17
# ╟─df6d5ba4-574c-44d2-8135-f9366fc4c1bb
# ╠═8409dd37-6f53-4caf-a239-bcaa0c0b79d4
# ╠═f800da38-ef07-48f1-a5b3-de2df7812de0
# ╠═d24cc858-c8b0-46a7-9bc5-316d7e1d922c
# ╟─1e258c09-aee0-483d-ac5e-9194cdf15455
# ╠═62bd4ba4-25c9-4f91-9d47-e3e7cffea47f
# ╟─d09015b3-1920-4820-89a9-da863486f386
# ╟─56dc1e4e-3d8d-4311-83b0-322ce014ceff
# ╠═acf0c3b9-2dd6-430d-b96f-9f4d187db0b7
# ╟─7d4b102f-63ab-43fe-a92b-cd2d4040a908
# ╠═244bdf17-b4d3-45f2-8fee-ee0494b5123e
# ╟─10490e62-3803-49d0-a927-469ac0a6049d
# ╟─d8a47a14-6f91-4ff8-801e-6353205babe9
# ╠═a92f1359-3e09-429c-8874-43abe19d9c05
# ╟─a5446a93-693b-480c-9420-f6228b4401c7
# ╠═4c4ded08-363c-4374-9b49-5a6925dda469
# ╟─b7b6b4a2-edef-460b-bc0b-c9f469c02371
# ╠═f80df167-98b4-41bf-be80-b85236f07546
# ╟─6c34ebc3-2a75-4007-b7bf-292294c407b8
# ╠═644f4678-dd01-49bd-9e9e-356047d8422a
# ╠═1c6718e7-bbb8-4076-822b-338b2a92a536
# ╟─1ef3b914-e503-4852-8448-dab30abca49d
# ╠═c7137e9c-fbd9-483e-bd27-14721eb342fd
# ╟─4fb8d205-130c-4fde-88ef-ed4d7b014cb5
# ╠═23857984-54a6-4850-b125-6325a9d81616
# ╟─f7875145-9938-4a42-99fe-744949792ce3
# ╟─03c781d5-395c-41f1-9a4e-f784663167d2
# ╠═94aa1b15-cd3f-4b57-a8a5-880e5ec79768
# ╟─4c561238-d187-439d-9598-ba3f94046206
# ╠═76745e6d-1edf-4a84-a809-5ecf25dd0776
# ╟─34b8d249-f4bf-4905-83d6-71358bd70726
# ╟─2c082ef8-4c74-4a2d-8683-398c02f1c5d5
# ╠═83c1ba16-a3db-40ea-9b9a-5a816af5993f
# ╟─2b5f6c4d-8b36-489f-9e78-d33d504e5add
# ╟─3a087963-7fa2-4286-9107-3bcbffeb6519
# ╟─ea822ea2-84e8-4a04-b7d9-0756342df25c
# ╟─d4eb4443-b7ea-4bd5-bbe3-22e23d50763d
# ╟─4f81497c-bde7-4063-b79c-fd855e087087
# ╟─5ba2baa0-549b-4870-8baf-d08ab9020394
# ╟─865765c1-9d6a-4c53-9c90-71175275039b
# ╠═c4fa3de9-a6fe-476b-a1b8-1821c9325255
# ╟─a934af87-adbf-4ac8-a03a-a312142953c0
# ╠═d68497bf-cb9a-4b89-b389-22c1c8db443c
# ╟─2381cd08-bf19-47dc-b5d3-7627abc895ce
# ╟─d9a8afc4-ade1-41e2-a3b5-472aeb2790c2
# ╠═0898c191-dc45-471d-b988-60135cb7a88f
# ╟─796208c6-6ce9-4bc0-b98e-2e366c7ec7b4
# ╠═67734a1f-b02d-4144-be59-cb61de57cfe0
# ╟─dd5a71c3-78c3-4fa5-beba-f683a5e7637c
# ╠═f1bc02fa-86a3-4daa-9d80-649503629158
# ╟─2611045a-5466-4201-ad0d-835c82b7b262
# ╠═6f630848-8d83-4bf0-a9d0-ef3a974d6038
# ╠═e556edc7-a57f-42b5-9c00-e8ec04b21126
# ╟─4427f969-9512-466e-adf4-dc86193b328d
# ╠═f661e0a7-9a4c-4a78-8a88-15a644e2a0eb
# ╟─800bba01-6fa7-47f9-a47b-56ab17c7ae9f
# ╠═d4f3b693-084e-43fa-bf0e-0f969817d49d
# ╟─3c8d293b-9783-4d38-880b-6cc5d014e4bd
# ╟─cec7f6bf-d65c-464a-8721-b25104d391b7
# ╟─5d88f1ad-ba91-4ad6-8811-f1bf9b13c252
# ╠═a7a939db-e19d-4cec-8bd7-4bdcb348b569
# ╟─27d4e0af-4ef1-49ca-917a-5f1430045d51
# ╟─96585ce4-4f13-45cc-8e2d-a4d93d0c56eb
# ╠═5489794f-1b94-4a0b-b9d2-3b626729b1bc
# ╟─332821ca-af0f-4005-8882-56ee8db8fd3b
# ╟─07771bf1-a370-408b-b567-4dbb88357c30
# ╟─4da35556-8b51-4cb2-bd01-1bdb6aa9bd41
# ╟─92ffd149-8d5f-4ad2-b7a6-f2722aeb91bc
# ╟─678c9022-34b1-48c5-9d03-571ef4c35e89
# ╟─80895e7e-e8f0-4d81-89a7-0dc3b88c60fe
# ╟─fa1ac74e-bb62-4366-b58e-3d0de0f489f4
# ╠═83e4e0a7-8e09-4f7e-aa79-57d47526e68d
# ╠═a2e2923a-dd73-400a-8771-e26c3290cb81
# ╟─7bacffab-69ee-43a6-a033-04590cc2148d
# ╠═7d12950b-8813-4165-bd52-49c5880970d5
# ╟─7eab1f4c-af65-4893-bf77-2fb148ed1e69
# ╟─48515007-88fb-494d-9e59-bf7902d021a1
# ╠═3dad3a1f-79c2-4913-8151-f0dfdf229285
# ╟─7b8f031b-1afa-4e5f-a33a-980f90b65c1f
# ╠═99ef4432-99e6-4e4f-97b8-22e0b6e9249a
# ╟─dc6247e4-4fd5-4630-b68f-273dc0c0f314
# ╟─f9de5b2c-5c50-46bb-8461-7359354672f4
# ╠═97068776-f732-492d-9501-5223d99b85ba
# ╟─a1003919-4324-43ef-afa6-49d1e7d092d5
# ╠═19110a58-1bae-43d2-8398-3bf7b9d9e7e5
# ╟─a4dda2e3-a5b9-406b-af0d-40b9ec6133de
# ╠═9fd9234c-4ae2-4fa4-8818-fabe8c760e5c
# ╟─9994161e-4951-4760-bb2e-6256e78ef02d
# ╠═68a0c0ed-aa53-4223-8541-e5969a3f5562
# ╠═ad9abed3-6efd-4ea1-8958-b1660503fb2b
# ╟─48557bcc-6852-4081-85d9-c7bf94674aee
# ╠═69ff1996-4f6e-49a1-811d-24cd3caa8c84
# ╟─2c37107e-7114-42a7-a538-797ab4bec8b9
# ╠═a28a4d79-c9db-4792-98bb-39c6418abf3b
# ╟─0f2e88e1-ba63-446e-8f78-03d899e1df05
# ╟─f25dad77-e5d6-4516-ab1b-2ff6a8c3cb8c
# ╠═9f10e79c-ecaa-4851-94d9-c26e0d5cc9a2
# ╟─b304b42f-47a7-468f-b045-8d0f70c039ca
# ╟─9716805e-4358-4ddd-879e-317c5ce3a477
# ╟─459fd343-55fc-4314-82e3-4d34ed301337
# ╠═a58b37ce-6abe-45b9-95a3-23debbce228e
# ╟─42e5d3d0-084e-4112-8b0d-2c52f0778780
# ╟─9d247ff1-3776-47cd-a067-88d72e6ac82e
# ╟─df76f922-6f95-425a-a07f-78cf94be87ad
# ╟─e12f6e11-d1ce-4543-ae8a-6109a6138526
# ╟─110c3b10-2364-46a9-82fe-d04667d80b86
# ╟─cf1b1b8b-8cde-4fb7-9705-dadca70d2e4f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
