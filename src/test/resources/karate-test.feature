Feature: Pruebas automatizadas Marvel Characters API

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'nenietor'
    * def basePath = '/' + username + '/api/characters'
    * configure ssl = true

  Scenario: Obtener todos los personajes
    Given path basePath
    When method get
    Then status 200
    And match response == '#[]'

  Scenario: Crear personaje válido
    Given path basePath
    And request { name: 'Spider-Man TEST NN', alterego: 'Peter Parker', description: 'Superhéroe arácnido de Marvel', powers: ['Agilidad', 'Sentido arácnido', 'Trepar muros'] }
    When method post
    Then status 201

  Scenario: Obtener personaje por ID (existente)
    Given path basePath, 5
    When method get
    Then status 200

  Scenario: Crear personaje con nombre duplicado (error 400)
    Given path basePath
    And request { name: 'Spider-Man', alterego: 'Peter Parker', description: 'Otro intento duplicado', powers: ['Agilidad'] }
    When method post
    Then status 400

  Scenario: Crear personaje con datos inválidos (error 400)
    Given path basePath
    And request { name: '', alterego: '', description: '', powers: [] }
    When method post
    Then status 400

  Scenario: Obtener personaje inexistente (error 404)
    Given path basePath, 999999999
    When method get
    Then status 404

  Scenario: Actualizar personaje (válido)
    Given path basePath, 5
    And request { name: 'Spider-Man NN(actualizado)', alterego: 'Peter Parker', description: 'Superhéroe arácnido de Marvel (actualizado)', powers: ['Agilidad', 'Sentido arácnido', 'Trepar muros'] }
    When method put
    Then status 200
    And match response.description contains 'actualizado'

  Scenario: Actualizar personaje inexistente (error 404)
    Given path basePath, 999999999
    And request { name: 'No existe', alterego: 'Nadie', description: 'No existe', powers: ['Nada'] }
    When method put
    Then status 404

  Scenario: Eliminar personaje (válido)
    Given path basePath, 8
    When method delete
    Then status 204

  Scenario: Eliminar personaje inexistente (error 404)
    Given path basePath, 999999999
    When method delete
    Then status 404
