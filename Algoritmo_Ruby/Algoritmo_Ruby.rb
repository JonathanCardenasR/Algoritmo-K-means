#Integrantes del Grupo
# Ners Armando Vasquez  Espinoza 20181987
# Angel Fabian lucana Tolentino 20182836
# Mauricio Enrique Santos Espino 20181762
# Jonathan Bruce Cárdenas Rondoño 20192549


#Clase Grupo que representa el el cluster
class Grupo
  attr_accessor :centroide,:primero,:ultimo
  def actualizarCentroide()
    temp = @primero
    cant=0
    var1=0
    var2=0
    var3=0
    var4 = 0
    while !(temp.nil?)
      cant = cant+1
      var1 = var1 + temp.sepal_length
      var2 = var2 + temp.sepal_width
      var3 = var3 + temp.petal_length
      var4 = var4 + temp.petal_width
      temp = temp.siguiente
    end
    @centroide.sepal_length= (var1/cant).round(1)
    @centroide.sepal_width= (var2/cant).round(1)
    @centroide.petal_length= (var3/cant).round(1)
    @centroide.petal_width= (var4/cant).round(1)
  end
  def calcularCantidad()
    temp = @primero
    cant=0
    while !(temp.nil?)
      cant=cant+1
      temp = temp.siguiente
    end
    return cant
  end
  def insertarAlFinal(nuevoIris)
      @primero = nuevoIris if @primero.nil?
      @ultimo.siguiente = nuevoIris unless @ultimo.nil?
      @ultimo = nuevoIris
  end
  def verLista()
    temp = @primero
    puts @centroide.imprimirIris
    while !(temp.nil?)
      puts temp.imprimirIris
      temp = temp.siguiente
    end
    puts " "
  end
end

#Clase Iris que contiene los datos de las dimensiones y adicionales
class Iris
  attr_accessor :sepal_length,:sepal_width,:petal_length,:petal_width,:species,:siguiente,:codigo
  def siguiente
    @enlace
  end
  def siguiente=(valor)
    @enlace = valor
  end
  def imprimirIris()
    @codigo.to_s+" "+@sepal_length.to_s+" "+@sepal_width.to_s+" "+@petal_length.to_s+" "+@petal_width.to_s+" "+@species.to_s
  end
end

# funcion que retorna un objeto de tipo iris con valores aleatorios
# que representa al centroide
def calcularCentroide(n)
  centroide = Iris.new()
  centroide.sepal_length= (rand()+rand(n)).round(1)
  centroide.sepal_width= (rand()+rand(n)).round(1)
  centroide.petal_length= (rand()+rand(n)).round(1)
  centroide.petal_width= (rand()+rand(n)).round(1)
  centroide.species= "centroide"
  return centroide
end

# compara el identificador del objeto iris
def compararIris(iris1,iris2)
  if(iris1.codigo == iris2.codigo)
    return true
  end
    return false
end

# compara dos cluster para ver si son iguales
def compararGrupos(grupo1,grupo2)
  temp1 = grupo1.primero
  temp2 = grupo2.primero
  resultado = true
  if (grupo1.calcularCantidad == 0 and grupo2.calcularCantidad==0)
    return true
  elsif (grupo1.calcularCantidad == grupo2.calcularCantidad)
    while !(temp1.nil?)
      resultado = compararIris(temp1,temp2)
      if(resultado==false)
        break
      end
      temp1 = temp1.siguiente
      temp2 = temp2.siguiente
    end
    return resultado
  else
    return false
  end
end

#calcula la distancia euclesiastica
def euclideanDistance(iris,centroide)
  dist = (iris.sepal_length-centroide.sepal_length)**2 +
  (iris.sepal_width-centroide.sepal_width)**2 +
  (iris.petal_length-centroide.petal_length)**2 +
  (iris.petal_width-centroide.petal_width)**2
  dist = Math.sqrt(dist)
  return dist
end

#se clona los valores de un grupo a otro grupo diferente (objeto nuevo no puntero)
def duplicarGrupo(grupo)
  nuevoGrupo = Grupo.new()
  nuevoGrupo.centroide=grupo.centroide
  temp=grupo.primero
  while !(temp.nil?)
    clonTemp = duplicarIris(temp)
    nuevoGrupo.insertarAlFinal(clonTemp)
    temp = temp.siguiente
  end
  return nuevoGrupo
end



#se clona los valores de un iris a otro iris diferente  (objeto nuevo no puntero)
def duplicarIris(iris)
  temp = Iris.new()
  temp.sepal_length  = iris.sepal_length
  temp.sepal_width  =  iris.sepal_width
  temp.petal_length  =  iris.petal_length
  temp.petal_width  =  iris.petal_width
  temp.species = iris.species
  temp.codigo = iris.codigo
  return temp
end

#se crean 3 grupos dependiendo del centroide de cada cluster
def separarGrupos(grupoPrincipal,grupo1,grupo2,grupo3)

  ## se recorre la Lista par separalo en grupos
  pMovil = grupoPrincipal.primero

  temp1=Grupo.new()
  temp2=Grupo.new()
  temp3=Grupo.new()

  temp1.centroide = duplicarIris(grupo1.centroide)
  temp2.centroide = duplicarIris(grupo2.centroide)
  temp3.centroide = duplicarIris(grupo3.centroide)

  while !(pMovil.nil?)
    temp = duplicarIris(pMovil)

    a = euclideanDistance(temp,temp1.centroide)
    b = euclideanDistance(temp,temp2.centroide)
    c = euclideanDistance(temp,temp3.centroide)

    if a < b && a < c
      temp1.insertarAlFinal(temp)
    elsif b < a && b < c
      temp2.insertarAlFinal(temp)
    elsif c < a && c < b
      temp3.insertarAlFinal(temp)
    elsif a == b
      temp1.insertarAlFinal(temp)
    elsif c == b
      temp2.insertarAlFinal(temp)
    elsif a == c
      temp1.insertarAlFinal(temp)
    else
      puts "algo fallo"
    end
    pMovil = pMovil.siguiente
  end
  return temp1,temp2,temp3
end

def irisAgrupados(grupoPrincipal,n)

  grupo1 = Grupo.new()
  grupo2 = Grupo.new()
  grupo3 = Grupo.new()

  grupo1r = Grupo.new()
  grupo2r = Grupo.new()
  grupo3r = Grupo.new()

  sinCambio= false

  #como recien inicia se calcula el centroide aleatoriao
  grupo1.centroide=calcularCentroide(n)
  grupo2.centroide=calcularCentroide(n)
  grupo3.centroide=calcularCentroide(n)

  while !(sinCambio)

    #se crea un grupoA,B y c para recibir los cluster creados
    # considerar que no se han modificado los grupo1 iniciales siguen con 0 0 0
    grupoA,grupoB,grupoC = separarGrupos(grupoPrincipal,grupo1,grupo2,grupo3)
    ## imprime valores intermedios de la lista para verificacion manual
    puts "Iteracion"
    puts "Grupo Letra"
    puts "#{grupoA.calcularCantidad()} #{grupoB.calcularCantidad()} #{grupoC.calcularCantidad()}"
    grupoA.verLista()
    grupoB.verLista()
    grupoC.verLista()

    puts "Iteracion"
    puts "Grupo Numero"
    puts "#{grupo1.calcularCantidad()} #{grupo2.calcularCantidad()} #{grupo3.calcularCantidad()}"
    grupo1.verLista()
    grupo2.verLista()
    grupo3.verLista()

    puts"---------------------------------------------------"

    if (compararGrupos(grupoA,grupo1) and compararGrupos(grupoB,grupo2) and compararGrupos(grupoC,grupo3))
      sinCambio=true

      grupo1r = duplicarGrupo(grupoA)
      grupo2r = duplicarGrupo(grupoB)
      grupo3r = duplicarGrupo(grupoC)

    else
      sinCambio=false

      #se carga al grupo1 con los objetos del grupoA para utilizarlos en la comparacion siguiente
      # y se descarta el grupo A
      grupo1.primero = grupoA.primero
      grupo1.ultimo = grupoA.ultimo

      unless grupo1.primero.nil?
        grupo1.actualizarCentroide
      end

      grupo2.primero = grupoB.primero
      grupo2.ultimo = grupoB.ultimo

      unless grupo2.primero.nil?
        grupo2.actualizarCentroide
      end

      grupo3.primero = grupoC.primero
      grupo3.ultimo = grupoC.ultimo

      unless grupo3.primero.nil?
        grupo3.actualizarCentroide
      end
    end
  end
  return grupo1r,grupo2r,grupo3r
end


#####
#####
#####
#aqui comienza el programa en si
#Lee el archivo y lo mete en un array
def main()
  iris_total = Array.new()
  File.readlines("iris.csv").drop(1).each do |file|
    arr = file.strip
    arr_iri=arr.split(',',-1)
    iris_total.push(arr_iri)
  end
  ##mete los array en una lista general de la calse iris
  grupoPrincipal = Grupo.new()

  for i in 0..(iris_total.length()-1)
    nuevoIris = Iris.new()
    nuevoIris.sepal_length  = iris_total[i][0].to_f
    nuevoIris.sepal_width  = iris_total[i][1].to_f
    nuevoIris.petal_length  = iris_total[i][2].to_f
    nuevoIris.petal_width  = iris_total[i][3].to_f
    nuevoIris.species = iris_total[i][4]
    nuevoIris.codigo = i
    grupoPrincipal.insertarAlFinal(nuevoIris)
  end

  max = 8


  grupo1r,grupo2r,grupo3r = irisAgrupados(grupoPrincipal,max)


  puts "Respuesta final"
  puts "#{grupo1r.calcularCantidad()} #{grupo2r.calcularCantidad()} #{grupo3r.calcularCantidad()}"
  grupo1r.verLista()

  grupo2r.verLista()

  grupo3r.verLista()
  puts "#{grupo1r.calcularCantidad()} #{grupo2r.calcularCantidad()} #{grupo3r.calcularCantidad()}"

end

main()
