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

    # --- เช็คราคารอบที่ 1 (Backpack เพียงชิ้นเดียว) ---
    ${item_total_raw}=    Get Text    css:[data-test="subtotal-label"]
    ${item_total}=        Evaluate    float('''${item_total_raw}'''.split('$')[-1])
    ${tax_raw}=           Get Text    css:[data-test="tax-label"]
    ${tax}=               Evaluate    float('''${tax_raw}'''.split('$')[-1])
    ${calculated_total}=  Evaluate    round(${item_total} + ${tax}, 2)
    ${total_raw}=         Get Text    css:[data-test="total-label"]
    ${total_actual}=      Evaluate    float('''${total_raw}'''.split('$')[-1])

    Should Be Equal As Numbers    ${total_actual}    ${calculated_total}    msg=ราคารวมรอบที่ 1 ไม่ถูกต้อง!
    Log To Console    === รอบที่ 1 (Backpack) ===
    Log To Console    Item Total: ${item_total}
    Log To Console    Tax: ${tax}
    Log To Console    Calculated: ${calculated_total}
    Log To Console    Actual: ${total_actual}

    # ============================================================
    # --- กลับไปหน้า Products แล้วเพิ่ม Sauce Labs Bike Light ---
    # ============================================================
    Click Button    id=cancel
    Wait Until Page Contains    Products    timeout=10s
    Wait Until Element Is Visible    xpath=//button[@data-test="add-to-cart-sauce-labs-bike-light"]    timeout=10s
    Click Button    xpath=//button[@data-test="add-to-cart-sauce-labs-bike-light"]

    # --- ไปตะกร้า และ Checkout อีกครั้ง ---
    Click Element   id=shopping_cart_container
    Wait Until Page Contains    Your Cart    timeout=10s
    Click Button    id=checkout

    # --- กรอกข้อมูล ---
    Wait Until Page Contains    Checkout: Your Information    timeout=10s
    Input Text      id=first-name    ${FIRST_NAME}
    Input Text      id=last-name     ${LAST_NAME}
    Input Text      id=postal-code   ${POSTAL_CODE}
    Click Button    id=continue
    Wait Until Page Contains    Checkout: Overview    timeout=10s

    # --- เช็คราคารอบที่ 2 (Backpack + Bike Light) ---
    ${item_total_raw}=    Get Text    css:[data-test="subtotal-label"]
    ${item_total}=        Evaluate    float('''${item_total_raw}'''.split('$')[-1])
    ${tax_raw}=           Get Text    css:[data-test="tax-label"]
    ${tax}=               Evaluate    float('''${tax_raw}'''.split('$')[-1])
    ${calculated_total}=  Evaluate    round(${item_total} + ${tax}, 2)
    ${total_raw}=         Get Text    css:[data-test="total-label"]
    ${total_actual}=      Evaluate    float('''${total_raw}'''.split('$')[-1])

    Should Be Equal As Numbers    ${total_actual}    ${calculated_total}    msg=ราคารวมรอบที่ 2 ไม่ถูกต้อง!
    Log To Console    === รอบที่ 2 (Backpack + Bike Light) ===
    Log To Console    Item Total: ${item_total}
    Log To Console    Tax: ${tax}
    Log To Console    Calculated: ${calculated_total}
    Log To Console    Actual: ${total_actual}