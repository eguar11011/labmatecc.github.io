---
title: "Álgebra Lineal"
permalink: /Notebooks/AlgebraLineal/
date: 2024-02-15
header-includes: |
    \usepackage{amsmath,mathtools}
---

<script
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
  type="text/javascript">
</script>

<html>
<head>
    <style>
        /* Estilos para centrar y cambiar el color del texto */
        h1 {
            text-align: center; /* Centra el texto horizontalmente */
            color: rgba(72, 133, 45, 0.76); /* Cambia el color del texto a verde */
        }
    </style>
</head>
<body>

<style>

    .container {
      max-width: 800px;
      margin: 20px auto;
      overflow: hidden;
    }

    .person {
      display: flex;
      margin-bottom: 20px;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
    }

    .person img {
      max-width: 200px;
      max-height: 200px;
      border-radius: 50%;
      margin-right: 20px;
      margin-left: 20px;
    }

    .person .info {
      flex: 1;
      text-align: left;
    }

    .person:nth-child(even) {
      flex-direction: row-reverse;
    }

    h2 {
      text-align: center;
      color: #333;
    }

    hr {
            border: none; /* Elimina el borde */
            height: 1px; /* Altura de la línea */
            background-color: #CCCCCC; /* Color de la línea */
            margin: 20px 0; /* Margen superior e inferior */
        }
  </style>

<hr>

<h1>Álgebra Lineal</h1>

<hr>

</body>
</html>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/Conceptosbasicos/" class="button">Conceptos básicos</a>
</div>

  <div class="container">
    <div class="person">
      <div class="info">
        <p>En este notebook, se presenta una introducción a las matrices. Se explica que una matriz es un conjunto rectangular de números, símbolos o expresiones organizados en filas y columnas, representados con letras mayúsculas y con su dimensión indicada por el número de filas y columnas. </p>

        <p>Se muestran ejemplos de matrices reales, simbólicas y de números complejos, junto con la explicación detallada de cómo acceder a elementos específicos y mostrar submatrices. Se introducen conceptos como matrices menores y por bloques, con ejemplos prácticos. </p>

        <p>Se exploran tipos de matrices como cuadradas, diagonales, identidad y nulas, con ejemplos aleatorios y operaciones básicas como suma y multiplicación por escalar. Se abordan operaciones más avanzadas, como la multiplicación de matrices por vectores, entre matrices y el producto de Kronecker, con ejemplos prácticos utilizando matrices aleatorias. </p>
      </div>
    </div>
  </div>

  <html>
<head>
    <style>
        .button-container {
            text-align: center; /* Centra el contenido horizontalmente */
        }

        .button {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 20px; /* Esto hace que el botón tenga forma de pastilla */
            background-color: rgba(72, 133, 45, 0.76); /* Cambia el color del botón a verde */
            color: white; /* Cambia el color del texto a blanco */
            text-decoration: none; /* Elimina el subrayado predeterminado en los enlaces */
            font-size: 16px; /* Cambia el tamaño del texto */
            font-weight: bold; /* Hace que el texto sea más audaz */
            border: none; /* Elimina el borde del botón */
        }
    </style>
</head>
<body>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/Vectores/" class="button">Vectores</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>El cuaderno comienza explicando los vectores como conjuntos ordenados de números, resaltando su representación en Julia mediante el tipo de dato Array. Se exploran operaciones básicas, como la dimensión del arreglo. </p>

        <p>Se detalla el acceso a elementos, introduciendo el uso de índices y la función \(\texttt{end}\). Se muestra cómo trabajar con subconjuntos de vectores mediante rangos. La comparación de vectores y la comparación de elementos individuales. </p>

        <p>Se introducen vectores nulos, canónicos y de unos, mostrando cómo construir manualmente vectores canónicos en Julia. Se utiliza el paquete Plots.jl para generar gráficos de vectores y visualizar datos.</p>

        <p>Las operaciones con vectores se abordan desde la suma componente a componente hasta la multiplicación y división por escalares, proporcionando ejemplos prácticos.</p>
      </div>
    </div>
  </div>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/Introduccionalprocesamientodeimagenes/" class="button">Introducción al procesamiento de imágenes</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>Se inicia con la definición de imágenes en blanco y negro y a color, destacando las representaciones numéricas de intensidad y los canales RGB. Muestra la creación interactiva del notebook se realiza a través de Pluto.jl, aprovechando librerías como Colors e ImageShow. También muestra la exploración de píxeles y matrices de píxeles revela las propiedades RGB y demuestra la manipulación eficiente de imágenes. Se abordan operaciones básicas, como selección de subimágenes y ajuste de tamaños, junto con el operador de Broadcasting. Además, se ejemplifican operaciones de procesamiento, como reducción de tamaño e inversión, utilizando álgebra lineal para reescalar píxeles y realizar combinaciones lineales. Finaliza mostrando filtros y kernels para las imágenes. </p>
      </div>
    </div>
  </div>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/Descripciondegrafosusandomatrices/" class="button">Descripción de grafos usando matrices</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>El cuaderno muestra conceptos fundamentales de grafos, como nodos, aristas y adyacencia, ilustrando con el problema de los Puentes de Königsberg. Se describen tipos de nodos y aristas, destacando la flexibilidad en la representación. A través de ejemplos, se construyen y visualizan grafos utilizando la librería GraphPlot. Se detallan las matrices de adyacencia e incidencia para representar conexiones entre nodos y aristas. Además, se presentan generadores de grafos incorporados</p>
      </div>
    </div>
  </div>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/Clustering/" class="button">Clustering</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>Comienza con una introducción al machine learning. Se destaca el uso de la distancia euclidiana en el contexto del clustering y se presenta una función para evaluar la calidad de los clusters. Luego, se introduce el algoritmo \(K\)-Means, con una implementación y un ejemplo de aplicación a datos generados aleatoriamente. Se aborda el preprocesamiento de datos, incluyendo la carga desde archivos y la generación aleatoria. Se detallan técnicas de normalización y estandarización, y se proporcionan funciones para Min-Máx y \(Z\)-Score. La visualización de datos antes y después de la normalización se muestra, seguida de la aplicación del algoritmo \(K\)-Means y la visualización de los clusters resultantes </p>
      </div>
    </div>
  </div>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/Independencialineal/" class="button">Independencia lineal I</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>El cuaderno comienza introduciendo el concepto de independencia lineal. Se define la dependencia e independencia lineal, relacionándolos con la existencia de combinaciones lineales no triviales. Se muestra un teorema clave que establece la relación de dependencia lineal entre dos vectores cuando uno es un múltiplo escalar del otro. Se ilustra este concepto con un ejemplo específico. Luego, se explora la relación entre matrices y la independencia lineal, destacando que las columnas de una matriz son linealmente independientes si y solo si el determinante de la matriz es diferente de cero.</p>
        <p>Se proporcionan ejemplos adicionales para determinar la dependencia o independencia lineal de conjuntos de vectores en \(\mathbb{R}^n.\) Se utiliza el concepto de determinante para tomar decisiones sobre la independencia lineal. Se introduce el concepto de base en un espacio vectorial y se demuestra que cualquier conjunto de \(n\) vectores linealmente independientes en \(\mathbb{R}^n\) genera todo el espacio. Se ilustra este teorema con un ejemplo específico.</p>
        <p>El cuaderno concluye abordando el tema de vectores ortonormales y presenta el proceso de ortogonalización de Gram-Schmidt para convertir un conjunto linealmente independiente en un conjunto ortonormal. Se describen las variantes clásica y modificada del algoritmo de Gram-Schmidt, y se demuestra su aplicación en un ejemplo práctico. Se proporciona código para implementar los algoritmos de Gram-Schmidt clásico y modificado, así como para verificar la ortogonalidad de matrices generadas.</p>
      </div>
    </div>
  </div>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/IndependencialinealII/" class="button">Independencia lineal II</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>Este notebook presenta una introducción a la factorización QR, un método clave para descomponer una matriz A en el producto de una matriz ortogonal Q y una matriz triangular superior R. La descomposición QR se utiliza para resolver sistemas de ecuaciones lineales y problemas de optimización. El cuaderno describe métodos para obtener la factorización QR, centrándose en las reflexiones de Householder y las rotaciones de Givens</p>
        <p>Primero, se explican las propiedades y el cálculo de las matrices de Householder, que se utilizan para transformar un vector en un múltiplo de un vector canónico, facilitando la ortogonalización de las columnas de una matriz. Se proporciona un algoritmo para calcular el vector y el coeficiente de Householder, junto con ejemplos prácticos. Luego, se muestra cómo usar las reflexiones de Householder para triangularizar una matriz y obtener la matriz R, así como la matriz Q mediante acumulación progresiva. Finalmente, se introducen las rotaciones de Givens, que son especialmente útiles para matrices dispersas, mostrando cómo aplicar estas rotaciones para lograr una factorización QR eficiente.</p>
      </div>
    </div>
  </div>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/Diagonalizacion/" class="button">Diagonalización (Sucesión de Fibonacci)</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>El cuaderno comienza con la importación de librerías. Luego, aborda el tema de matrices semejantes, proporciona definiciones y ejemplos. También incluye un teorema que establece que matrices semejantes tienen el mismo polinomio característico y, por lo tanto, los mismos valores propios. Se presentan ejemplos de matrices semejantes y se verifica que comparten los valores propios. Luego, se introduce el concepto de matriz diagonalizable, junto con un teorema que establece las condiciones para que una matriz sea diagonalizable. Se presenta un corolario que afirma que si una matriz tiene valores propios distintos, entonces es diagonalizable. Se proporcionan ejemplos de matrices diagonalizables y se calculan sus valores y vectores propios. Posteriormente, se explora la aplicación de estos conceptos a la sucesión de Fibonacci. Se describe cómo se puede expresar el sistema recursivo de Fibonacci en términos matriciales y se muestra cómo calcular directamente el n-ésimo número de Fibonacci mediante la diagonalización de la matriz asociada. Se implementa una función para calcular \(F_n\) de manera eficiente utilizando la diagonalización. </p>
      </div>
    </div>
  </div>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/SVD/" class="button">Compresión de imágenes (SVD)</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>En este cuaderno, se presentan definiciones de valor y vector propio. Posteriormente, se muestra cómo hallar los valores singulares de una matriz. A continuación, se detalla la descomposición en valores singulares (SVD) con diversos ejemplos. Luego, nos enfocamos en la descomposición en valores singulares reducida, que es la que utiliza Julia, y se muestran ejemplos específicos.
        Después de explorar la SVD, se muestra la compresión de imágenes. Este proceso implica realizar la SVD de la imagen y luego truncar dicha descomposición en \(k\) valores singulares (se realiza esto en cada canal de color para luego ensamblar nuevamente la imagen). Con este concepto presente, se presenta la creación de una marca de agua digital. Esta técnica permite personalizar imágenes sin que sea perceptible al ojo humano. La marca de agua se inserta creando una perturbación en la matriz \(V\). Una vez que la imagen está marcada, se muestra cómo deducir y recuperar la marca de agua. </p>
      </div>
    </div>
  </div>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/PCA/" class="button">Análisis de componentes principales (PCA)</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>Este cuaderno aborda el Método de Análisis de Componentes Principales (PCA), una técnica de reducción de dimensionalidad. Comienza explicando conceptos como la media y la varianza en un conjunto de datos. Luego, se presenta la covarianza y la matriz de covarianza, seguidas por el proceso detallado de cómo se emplea el PCA. Se describen los pasos desde la centralización de datos y cálculo de la matriz de covarianza hasta la reconstrucción de datos y la compresión de imágenes utilizando las componentes principales. Se muestra cómo la compresión efectiva mantiene la información esencial de la imagen original mientras reduce su dimensionalidad. Además, se incluyen ejemplos prácticos de compresión de imágenes con diferentes números de componentes principales y se evalúa el error de compresión en cada caso. </p>
      </div>
    </div>
  </div>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/Sistemasdeecuacionesdiferenciales/" class="button">Sistemas de ecuaciones diferenciales</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>Se comienza con una introducción sobre ecuaciones diferenciales, destacando la forma general de las ecuaciones de primer orden y proporcionando un ejemplo específico. Luego, presentan una solución numérica para el ejemplo utilizando la biblioteca DifferentialEquations de Julia.</p>
        <p>El cuaderno continúa con una sección sobre sistemas lineales homogéneos. Se introduce la notación matricial y se explica cómo resolver sistemas lineales homogéneos mediante el uso de matrices diagonalizables. Se presenta un ejemplo concreto, mostrando cómo la solución general de un sistema homogéneo se puede expresar en términos de los vectores propios y valores propios de la matriz asociada al sistema. Luego, se muestra cómo resolver un sistema específico con condiciones iniciales dadas.</p>
      </div>
    </div>
  </div>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/CirculosDeGershgorin/" class="button">Círculos de Gershgorin</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>Este cuaderno muestra los métodos de localización de valores propios, comenzando con el Teorema de Gershgorin, que establece que todos los valores propios de una matriz están contenidos en la unión de discos en el plano complejo. Luego, se extiende la teoría a los discos de Brauer y a los discos generalizados de Gershgorin, mostrando mejoras en las estimaciones sobre la ubicación de los valores propios. Además, se proporciona una serie de ejemplos prácticos que ilustran la aplicación de estos teoremas y métodos, mostrando cómo se pueden visualizar los discos correspondientes para diferentes matrices y cómo estos métodos pueden ser utilizados en la práctica para análisis y simulaciones.</p>
      </div>
    </div>
  </div>

<hr>

<div class="button-container">
  <a href="https://labmatecc.github.io/Notebooks/AlgebraLineal/Minimoscuadrados/" class="button">Mínimos cuadrados</a>
</div>

<div class="container">
    <div class="person">
      <div class="info">
        <p>El cuaderno proporciona una introducción al método de mínimos cuadrados, destacando su aplicación para resolver sistemas sobredeterminados de ecuaciones lineales. Luego, se presenta un ejemplo con datos y se resuelve utilizando el operador de backslash (\) en Julia.</p>
        <p>Posteriormente, el cuaderno aborda el ajuste por mínimos cuadrados en el contexto de la regresión lineal y presenta un ejemplo específico de ajuste polinomial. Se describe cómo se puede aplicar el método para encontrar un polinomio de grado específico que se ajuste de manera óptima a un conjunto de datos dado. Finalmente, se explora el ajuste por mínimos cuadrados de ecuaciones cuadráticas en las variables \(x\) e \(y\), y se proporciona un ejemplo práctico con datos que se ajustan a una elipse.</p>
      </div>
    </div>
  </div>