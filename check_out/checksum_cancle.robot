*** Settings ***
Library           SeleniumLibrary

Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}       https://www.saucedemo.com
${BROWSER}        chrome
${USERNAME}       standard_user
${PASSWORD}       secret_sauce
${FIRST_NAME}     สมชาย
${LAST_NAME}      แซ่ตั้ง
${POSTAL_CODE}    10110

*** Test Cases ***
Verify Total Price On Checkout Overview
    [Documentation]    เช็คราคาครั้งแรก (Backpack) แล้วเพิ่ม Bike Light แล้วเช็คราคาอีกครั้ง

    # --- Login ---
    ${chrome_options}=    Evaluate
    ...    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    &{prefs}=            Create Dictionary    profile.password_manager_leak_detection=${False}
    Call Method          ${chrome_options}    add_experimental_option    prefs    ${prefs}
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    Input Text      id=user-name    ${USERNAME}
    Input Text      id=password     ${PASSWORD}
    Click Button    id=login-button

    # --- เพิ่มสินค้าชิ้นที่ 1: Sauce Labs Backpack ---
    Wait Until Element Is Visible    xpath=//button[@data-test="add-to-cart-sauce-labs-backpack"]
    Click Button    xpath=//button[@data-test="add-to-cart-sauce-labs-backpack"]

    # --- ไปตะกร้า และ Checkout ---
    Click Element   id=shopping_cart_container
    Wait Until Page Contains    Checkout    timeout=10s
    Click Button    id=checkout

    # --- กรอกข้อมูล ---
    Wait Until Page Contains    Checkout: Your Information    timeout=10s
    Input Text      id=first-name    ${FIRST_NAME}
    Input Text      id=last-name     ${LAST_NAME}
    Input Text      id=postal-code   ${POSTAL_CODE}
    Click Button    id=continue
    Wait Until Page Contains    Checkout: Overview    timeout=10s

    # --- กลับไปหน้า Products ---
    Click Button    id=cancel
    Wait Until Page Contains    Products    timeout=10s