*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}        https://www.saucedemo.com/
${BROWSER}    chrome
${USERNAME}   standard_user
${PASSWORD}   secret_sauce

*** Test Cases ***
Verify Cart Order And Re-Add Item
    Open Browser And Login

    # 1. เพิ่มสินค้า 3 ชิ้น
    Click Button    id=add-to-cart-sauce-labs-backpack
    Click Button    id=add-to-cart-sauce-labs-bike-light
    Click Button    id=add-to-cart-sauce-labs-bolt-t-shirt

    # 2. คลิก cart icon
    Click Element    css=.shopping_cart_link
    Wait Until Element Is Visible    css=.cart_list    timeout=10s

    # 3. เช็คลำดับสินค้าใน cart (กดก่อน = อยู่บน, กดหลัง = อยู่ล่าง)
    ${items}=    Get WebElements    css=.cart_item .inventory_item_name
    Should Be Equal    ${items[0].text}    Sauce Labs Backpack
    Should Be Equal    ${items[1].text}    Sauce Labs Bike Light
    Should Be Equal    ${items[2].text}    Sauce Labs Bolt T-Shirt

    # 4. ลบสินค้าอันแรก (Sauce Labs Backpack)
    Click Button    id=remove-sauce-labs-backpack
    Wait Until Element Is Not Visible    xpath=//div[@class='inventory_item_name'][text()='Sauce Labs Backpack']    timeout=5s
    ${items_after_remove}=    Get WebElements    css=.cart_item .inventory_item_name
    Length Should Be    ${items_after_remove}    2
    Should Be Equal    ${items_after_remove[0].text}    Sauce Labs Bike Light
    Should Be Equal    ${items_after_remove[1].text}    Sauce Labs Bolt T-Shirt

    # 5. กลับไปหน้าเลือกสินค้า แล้วเพิ่ม Sauce Labs Backpack อีกครั้ง
    Click Button    id=continue-shopping
    Wait Until Element Is Visible    css=.inventory_list    timeout=10s
    Click Button    id=add-to-cart-sauce-labs-backpack

    # 6. คลิก cart icon แล้วเช็คว่า Sauce Labs Backpack อยู่ลำดับสุดท้าย
    Click Element    css=.shopping_cart_link
    Wait Until Element Is Visible    css=.cart_list    timeout=10s
    ${items_final}=    Get WebElements    css=.cart_item .inventory_item_name
    Length Should Be    ${items_final}    3
    Should Be Equal    ${items_final[0].text}    Sauce Labs Bike Light
    Should Be Equal    ${items_final[1].text}    Sauce Labs Bolt T-Shirt
    Should Be Equal    ${items_final[2].text}    Sauce Labs Backpack

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