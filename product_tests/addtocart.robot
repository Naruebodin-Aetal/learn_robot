*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}        https://www.saucedemo.com/
${BROWSER}    chrome
${USERNAME}   standard_user
${PASSWORD}   secret_sauce

*** Test Cases ***
Add All Products To Cart
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login To SauceDemo
    Click Button    id=add-to-cart-sauce-labs-backpack
    Click Button    id=add-to-cart-sauce-labs-bike-light
    Click Button    id=add-to-cart-sauce-labs-bolt-t-shirt
    Click Button    id=add-to-cart-sauce-labs-fleece-jacket
    Click Button    id=add-to-cart-sauce-labs-onesie
    Click Button    id=add-to-cart-test.allthethings()-t-shirt-(red)
    Element Text Should Be    class=shopping_cart_badge    6
    Close Browser


Remove All Products From Cart
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login To SauceDemo
    Add All Products
    Click Button    id=remove-sauce-labs-backpack
    Click Button    id=remove-sauce-labs-bike-light
    Click Button    id=remove-sauce-labs-bolt-t-shirt
    Click Button    id=remove-sauce-labs-fleece-jacket
    Click Button    id=remove-sauce-labs-onesie
    Click Button    id=remove-test.allthethings()-t-shirt-(red)
    Element Should Not Be Visible    class=shopping_cart_badge
    Close Browser


*** Keywords ***
Login To SauceDemo
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Wait Until Element Is Visible    class=inventory_list


Add All Products
    Click Button    id=add-to-cart-sauce-labs-backpack
    Click Button    id=add-to-cart-sauce-labs-bike-light
    Click Button    id=add-to-cart-sauce-labs-bolt-t-shirt
    Click Button    id=add-to-cart-sauce-labs-fleece-jacket
    Click Button    id=add-to-cart-sauce-labs-onesie
    Click Button    id=add-to-cart-test.allthethings()-t-shirt-(red)