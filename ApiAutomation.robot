*** Settings ***
Suite Setup       Log    I am inside Suite Setup
Suite Teardown    Log    I am inside Suite Teardown
Test Setup        Log    I am inside Test Setup
Test Teardown     Log    I am inside Test Teardown
Library           RequestsLibrary
Library           Collections
Library           JSONLibrary
Library           os
Library           rf_userdefined_keywords.py

*** Variables ***
${BASE_URL}       http://thetestingworldapi.com/
${COMPLEX_BASE_URL}    http://restcountries.eu/

*** Test Cases ***
TC_001_GET_REQUEST
    create_session    Get_Student_Details    ${BASE_URL}
    ${response}    GET On Session    Get_Student_Details    api/studentsDetails
    #Log    ${response}
    log to console    ${response.status_code}
    Log    ${response.content}
    ${status_code}    convert to string    ${response.status_code}
    should be equal    ${status_code}    200
    ${body}    convert to string    ${response.content}
    should contain    ${body}    first_name
    Log    ${response.headers}
    ${content_type_value}    get from dictionary    ${response.headers}    Content-Type
    should be equal    ${content_type_value}    application/json; charset=utf-8

TC_002_POST_REQUEST
    create_session    my_session    ${BASE_URL}
    ${body}    create dictionary    first_name=Sai    middle_name=Naga    last_name=Krishna    date_of_birth=01-01-01
    #${header}    create dictionary    Content-Type=application/json
    ${response}    POST On Session    my_session    /api/studentsDetails    data=${body}    #headers=${header}
    log to console    ${response.status_code}
    log to console    ${response.content}
    log to console    ${response.headers}

TC_003_LOAD_AND_VALIDATE_JSON_FILE
    ${json_object}    load json from file    D:/NaveeN Python/Robot Framework/json_file.json    #os is to load the path of file
    ${name_val}    get value from json    ${json_object}    $.firstName    # this is xpath
    log to console    ${name_val[0]}
    should be equal    ${name_val[0]}    John
    ${address_val}    get value from json    ${json_object}    $.address.streetAddress
    log to console    ${address_val[0]}
    should be equal    ${address_val[0]}    naist street
    ${mobile_val}    get value from json    ${json_object}    $.phoneNumbers[1].number
    log to console    ${mobile_val[0]}
    should be equal    ${mobile_val[0]}    0123-4567-8910

TC_004_VALIDATE_COMPLEX_DATA
    create_session    my_session    ${COMPLEX_BASE_URL}
    ${response}    GET On Session    my_session    rest/v2/alpha/IN
    ${json_obj}    set variable    ${response.json()}
    #log to console    ${json_obj}
    # Single data validation
    ${country_name}    get value from json    ${json_obj}    $.name
    should be equal    ${country_name[0]}    India
    # Single data validation in a array
    ${border_name}    get value from json    ${json_obj}    $.borders[0]
    should be equal    ${border_name[0]}    AFG
    # Multiple data validation in a array
    ${borders}    get value from json    ${json_obj}    $.borders
    log to console    ${borders[0]}
    ${type string}=    Evaluate    type($borders[0])    # get the data type
    Log To Console    ${type string}
    ${validate_values}    Create list    NPL    AFG    PAK
    List Should Contain Sub List    ${borders[0]}    ${validate_values}
    should not contain any    ${borders[0]}    abc    xyz

TC_005_TEST_USER_DEFINED_KEYWORDS
    PRINT
    rf_userdefined_keywords.concatinate    Hello    Bharath

*** Keywords ***
PRINT
    ${result}    Evaluate    3 * 4
    Log To Console    Equals to ${result}
    log to console    I am 1
    log to console    I am 2
