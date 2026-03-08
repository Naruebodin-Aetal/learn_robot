*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}        https://www.saucedemo.com/
${BROWSER}    chrome
${USERNAME}   standard_user
${PASSWORD}   secret_sauce

*** Test Cases ***
Verify Cart Count After Add Products
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login To SauceDemo
    Click Button    id=add-to-cart-sauce-labs-backpack
    Click Button    id=add-to-cart-sauce-labs-bike-light
    Click Button    id=add-to-cart-sauce-labs-bolt-t-shirt
    Element Text Should Be    class=shopping_cart_badge    3
    Close Browser


Verify Cart Count After Remove Product
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login To SauceDemo
    Click Button    id=add-to-cart-sauce-labs-backpack
    Click Button    id=add-to-cart-sauce-labs-bike-light
    Click Button    id=add-to-cart-sauce-labs-bolt-t-shirt
    Element Text Should Be    class=shopping_cart_badge    3

    Click Button    id=remove-sauce-labs-bike-light
    Element Text Should Be    class=shopping_cart_badge    2
    Close Browser


*** Keywords ***
Login To SauceDemo
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Wait Until Element Is Visible    class=inventory_list