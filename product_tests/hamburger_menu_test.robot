*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}        https://www.saucedemo.com/
${BROWSER}    chrome
${USERNAME}   standard_user
${PASSWORD}   secret_sauce

*** Test Cases ***
Verify All Items Button
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login To SauceDemo
    Open Hamburger Menu
    Click Element    id=inventory_sidebar_link
    Element Should Contain    class=title    Products
    Close Browser


Verify About Button
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login To SauceDemo
    Open Hamburger Menu
    Click Element    id=about_sidebar_link
    Location Should Contain    saucelabs
    Close Browser


Verify Logout Button
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login To SauceDemo
    Open Hamburger Menu
    Click Element    id=logout_sidebar_link
    Element Should Be Visible    id=login-button
    Close Browser


Verify Reset App State Button
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Login To SauceDemo
    Click Button    id=add-to-cart-sauce-labs-backpack
    Element Text Should Be    class=shopping_cart_badge    1

    Open Hamburger Menu
    Click Element    id=reset_sidebar_link

    Element Should Not Be Visible    class=shopping_cart_badge
    Close Browser


*** Keywords ***
Login To SauceDemo
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Wait Until Element Is Visible    class=inventory_list

Open Hamburger Menu
    Click Button    id=react-burger-menu-btn
    Wait Until Element Is Visible    id=inventory_sidebar_link