*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}        https://www.saucedemo.com/
${BROWSER}    chrome
${USERNAME}   standard_user
${PASSWORD}   secret_sauce

*** Test Cases ***
Verify Backpack Product Detail
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login To SauceDemo
    Click Element    id=item_4_title_link
    Element Should Be Visible    class=inventory_details_img
    Element Should Contain    class=inventory_details_name    Sauce Labs Backpack
    Element Should Be Visible    class=inventory_details_desc
    Close Browser


Verify Bike Light Product Detail
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login To SauceDemo
    Click Element    id=item_0_title_link
    Element Should Be Visible    class=inventory_details_img
    Element Should Contain    class=inventory_details_name    Sauce Labs Bike Light
    Element Should Be Visible    class=inventory_details_desc
    Close Browser


Verify Bolt T-Shirt Product Detail
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login To SauceDemo
    Click Element    id=item_1_title_link
    Element Should Be Visible    class=inventory_details_img
    Element Should Contain    class=inventory_details_name    Sauce Labs Bolt T-Shirt
    Element Should Be Visible    class=inventory_details_desc
    Close Browser


*** Keywords ***
Login To SauceDemo
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Wait Until Element Is Visible    class=inventory_list