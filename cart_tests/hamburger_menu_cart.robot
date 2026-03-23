*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}        https://www.saucedemo.com/
${BROWSER}    chrome
${USERNAME}   standard_user
${PASSWORD}   secret_sauce

*** Test Cases ***
Verify Hamburger Menu All Items In Cart Page
    Open Browser And Login
    Add Item To Cart And Go To Cart    id=add-to-cart-sauce-labs-backpack
    Click Sidebar Menu Item    id=inventory_sidebar_link
    Element Should Contain    css=.title    Products
    [Teardown]    Close Browser

Verify Hamburger Menu About In Cart Page
    Open Browser And Login
    Add Item To Cart And Go To Cart    id=add-to-cart-sauce-labs-backpack
    Click Sidebar Menu Item    id=about_sidebar_link
    Wait Until Location Contains    saucelabs    timeout=10s
    Location Should Contain    saucelabs
    [Teardown]    Close Browser

Verify Hamburger Menu Logout In Cart Page
    Open Browser And Login
    Add Item To Cart And Go To Cart    id=add-to-cart-sauce-labs-backpack
    Click Sidebar Menu Item    id=logout_sidebar_link
    Wait Until Location Contains    saucedemo.com    timeout=10s
    Element Should Be Visible    id=login-button
    [Teardown]    Close Browser

Verify Hamburger Menu Reset App State In Cart Page
    Open Browser And Login
    Add Item To Cart And Go To Cart    id=add-to-cart-sauce-labs-backpack
    Wait Until Element Is Visible    css=.shopping_cart_badge    timeout=5s
    Element Should Contain    css=.shopping_cart_badge    1
    Click Sidebar Menu Item    id=reset_sidebar_link
    Wait Until Page Does Not Contain Element    css=.shopping_cart_badge    timeout=10s
    Element Should Not Be Visible    css=.shopping_cart_badge
    Wait Until Page Does Not Contain Element    css=.cart_item    timeout=10s
    ${cart_items}=    Get WebElements    css=.cart_item
    Length Should Be    ${cart_items}    0
    [Teardown]    Close Browser

*** Keywords ***
Open Browser And Login
    ${prefs}=    Create Dictionary
    ...    credentials_enable_service=${False}
    ...    profile.password_manager_enabled=${False}
    ...    profile.password_manager_leak_detection=${False}
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    selenium.webdriver
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    Evaluate    $options.add_argument('--disable-save-password-bubble')
    Evaluate    $options.add_argument('--disable-features=PasswordManagerTriggerFormSubmission')
    Evaluate    $options.add_argument('--no-default-browser-check')
    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Login To SauceDemo

Login To SauceDemo
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Wait Until Element Is Visible    css=.inventory_list    timeout=10s

Add Item To Cart And Go To Cart
    [Arguments]    ${item_locator}
    Click Button    ${item_locator}
    Wait Until Element Is Visible    css=.shopping_cart_badge    timeout=5s
    Click Element    css=.shopping_cart_link
    Wait Until Element Is Visible    css=.cart_list    timeout=10s

Open Hamburger Menu
    Wait Until Element Is Visible    id=react-burger-menu-btn    timeout=10s
    Click Button    id=react-burger-menu-btn
    Wait Until Element Is Visible    id=inventory_sidebar_link    timeout=10s

Click Sidebar Menu Item
    [Arguments]    ${locator}
    Open Hamburger Menu
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Wait Until Element Is Enabled    ${locator}    timeout=10s
    Scroll Element Into View    ${locator}
    ${clicked}=    Run Keyword And Return Status    Click Element    ${locator}
    IF    not ${clicked}
        ${element}=    Get WebElement    ${locator}
        Execute JavaScript    arguments[0].click();    ARGUMENTS    ${element}
    END