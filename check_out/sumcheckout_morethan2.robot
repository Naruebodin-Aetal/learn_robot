*** Settings ***
Library           SeleniumLibrary
Library           String

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
Verify Multiple Items Total Price
    [Documentation]    เลือกสินค้า 2 ชิ้น และตรวจสอบว่า Item Total + Tax = Total จริงไหม
    
    # --- Step 1: Login ---
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Input Text      id=user-name    ${USERNAME}
    Input Text      id=password     ${PASSWORD}
    Click Button    id=login-button
    
    # --- Step 2: เพิ่มสินค้า 2 ชิ้น ---
    # ชิ้นที่ 1: Backpack ($29.99)
    Wait Until Element Is Visible    xpath=//button[@data-test="add-to-cart-sauce-labs-backpack"]
    Click Button                     xpath=//button[@data-test="add-to-cart-sauce-labs-backpack"]
    
    # ชิ้นที่ 2: Bike Light ($9.99)
    Wait Until Element Is Visible    xpath=//button[@data-test="add-to-cart-sauce-labs-bike-light"]
    Click Button                     xpath=//button[@data-test="add-to-cart-sauce-labs-bike-light"]
    
    # --- Step 3: ไปที่หน้า Cart และ Checkout ---
    Click Element                    id=shopping_cart_container
    
    # แก้ปัญหา "id=checkout not found" ด้วยการรอให้ปุ่มปรากฎ
    Wait Until Element Is Visible    id=checkout    timeout=10s
    Click Button                     id=checkout

    # --- Step 4: กรอกข้อมูลผู้รับ ---
    Wait Until Element Is Visible    id=first-name    timeout=5s
    Input Text      id=first-name    ${FIRST_NAME}
    Input Text      id=last-name     ${LAST_NAME}
    Input Text      id=postal-code   ${POSTAL_CODE}
    Click Button    id=continue 

    # --- Step 5: ตรวจสอบหน้า Overview ---
    Wait Until Page Contains    Checkout: Overview    timeout=10s

    # ดึงค่า Item Total (ยอดรวมสินค้า 2 ชิ้นก่อนภาษี)
    ${item_total_raw}=    Get Text    css:[data-test="subtotal-label"]
    ${item_total}=        Evaluate    float('''${item_total_raw}'''.split('$')[-1])

    # ดึงค่า Tax (ภาษี)
    ${tax_raw}=           Get Text    css:[data-test="tax-label"]
    ${tax}=               Evaluate    float('''${tax_raw}'''.split('$')[-1])

    # ดึงค่า Total Actual (ยอดรวมสุทธิที่ต้องจ่าย)
    ${total_raw}=         Get Text    css:[data-test="total-label"]
    ${total_actual}=      Evaluate    float('''${total_raw}'''.split('$')[-1])

    # --- Step 6: Verify Logic ---
    ${calculated_total}=  Evaluate    ${item_total} + ${tax}
    
    # แสดงค่าที่ดึงได้ลง Console เพื่อตรวจสอบ
    Log To Console    \n--- Price Summary ---
    Log To Console    Item Total (2 items): ${item_total}
    Log To Console    Tax: ${tax}
    Log To Console    Calculated Sum: ${calculated_total}
    Log To Console    Actual Displayed: ${total_actual}

    Should Be Equal As Numbers    ${total_actual}    ${calculated_total}    msg=ราคารวมสุดท้ายไม่ถูกต้อง!