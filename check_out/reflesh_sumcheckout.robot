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
    [Documentation]    กรอกข้อมูลและตรวจสอบการคำนวณราคารวม
    
    # --- Step 0-4: Login และไปที่หน้า Checkout ---
    ${chrome_options}=    Evaluate
    ...    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver 
    &{prefs}=            Create Dictionary    profile.password_manager_leak_detection=${False}
    Call Method          ${chrome_options}    add_experimental_option    prefs    ${prefs} 
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${chrome_options} 
    Maximize Browser Window
    Input Text      id=user-name    ${USERNAME}
    Input Text      id=password     ${PASSWORD}
    Click Button    id=login-button
    
    Wait Until Element Is Visible    xpath=//button[@data-test="add-to-cart-sauce-labs-backpack"] 
    Click Button    xpath=//button[@data-test="add-to-cart-sauce-labs-backpack"]
    
    Click Element   id=shopping_cart_container
    Click Button    id=checkout

    # --- Step 5-6: กรอกข้อมูล ---
    Input Text      id=first-name    ${FIRST_NAME}
    Input Text      id=last-name     ${LAST_NAME}
    Input Text      id=postal-code   ${POSTAL_CODE}
    wait until page contains    Checkout: Your Information    timeout=10s
    
    # ต้องกด Continue เพื่อไปหน้าสรุปราคา
    Click Button    id=continue 
    Wait Until Page Contains    Checkout: Overview    timeout=10s

    # --- Step 7: ดึงราคารวมสินค้า ---
    ${item_total_raw}=    Get Text    css:[data-test="subtotal-label"]
    ${item_total}=        Evaluate    float('''${item_total_raw}'''.split('$')[-1])

    # --- Step 8: ดึงราคาภาษี ---
    ${tax_raw}=           Get Text    css:[data-test="tax-label"]
    ${tax}=               Evaluate    float('''${tax_raw}'''.split('$')[-1])

    # --- Step 9: คำนวณราคารวม (Logic) ---
    ${calculated_total}=  Evaluate    ${item_total} + ${tax}
    
    # ดึงค่า Total Actual จากหน้าเว็บ
    ${total_raw}=         Get Text    css:[data-test="total-label"]
    ${total_actual}=      Evaluate    float('''${total_raw}'''.split('$')[-1])

    # --- Step 10: ตรวจสอบราคารวม ---
    Should Be Equal As Numbers    ${total_actual}    ${calculated_total}    msg=ราคารวมไม่ถูกต้อง!
    Log To Console    \nCalculated: ${calculated_total} | Actual: ${total_actual}

    # --- Step 11: รีเฟรชหน้าและตรวจสอบว่าราคาสินค้าเท่าเดิม ---
    ${backpack_price_before_raw}=    Get Text    xpath=//div[contains(@class,'cart_item') and .//div[contains(@class,'inventory_item_name') and normalize-space()='Sauce Labs Backpack']]//div[contains(@class,'inventory_item_price')]
    ${backpack_price_before}=        Evaluate    float('''${backpack_price_before_raw}'''.split('$')[-1])

    Reload Page
    Wait Until Page Contains Element    xpath=//div[contains(@class,'cart_item') and .//div[contains(@class,'inventory_item_name') and normalize-space()='Sauce Labs Backpack']]//div[contains(@class,'inventory_item_price')]    timeout=10s
    ${backpack_price_after_raw}=     Get Text    xpath=//div[contains(@class,'cart_item') and .//div[contains(@class,'inventory_item_name') and normalize-space()='Sauce Labs Backpack']]//div[contains(@class,'inventory_item_price')]
    ${backpack_price_after}=         Evaluate    float('''${backpack_price_after_raw}'''.split('$')[-1])

    Should Be Equal As Numbers    ${backpack_price_after}    ${backpack_price_before}    msg=ราคา Sauce Labs Backpack เปลี่ยนหลังรีเฟรชหน้า
    Log To Console    \nBackpack Price Before Refresh: ${backpack_price_before} | After Refresh: ${backpack_price_after}