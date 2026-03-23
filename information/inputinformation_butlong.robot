*** Settings ***
Library           SeleniumLibrary

Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}       https://www.saucedemo.com
${BROWSER}        chrome
${USERNAME}       standard_user
${PASSWORD}       secret_sauce
${FIRST_NAME}     กรุงเทพมหานคร อมรรัตนโกสินทร์ มหินทรายุธยา มหาดิลกภพ นพรัตนราชธานีบูรีรมย์ อุดมราชนิเวศน์มหาสถาน อมรพิมานอวตารสถิต สักกะทัตติยวิษณุกรรมประสิทธิ์
${LAST_NAME}      กรุงเทพมหานคร อมรรัตนโกสินทร์ มหินทรายุธยา มหาดิลกภพ นพรัตนราชธานีบูรีรมย์ อุดมราชนิเวศน์มหาสถาน อมรพิมานอวตารสถิต สักกะทัตติยวิษณุกรรมประสิทธิ์
${POSTAL_CODE}    กรุงเทพมหานคร อมรรัตนโกสินทร์ มหินทรายุธยา มหาดิลกภพ นพรัตนราชธานีบูรีรมย์ อุดมราชนิเวศน์มหาสถาน อมรพิมานอวตารสถิต สักกะทัตติยวิษณุกรรมประสิทธิ์

*** Test Cases ***
Fill Information Page
    [Documentation]    กรอกข้อมูลทุกช่องในหน้า Checkout Information

    # Step 0: เปิด Browser และขยายเต็มจอ
    ${chrome_options}=    Evaluate
    ...    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    Call Method          ${chrome_options}    add_experimental_option    detach    ${True}
    &{prefs}=            Create Dictionary    profile.password_manager_leak_detection=${False}
    Call Method          ${chrome_options}    add_experimental_option    prefs    ${prefs}
    Open Browser          ${BASE_URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    Sleep                 1s

    # Step 1: Login
    Input Text            id=user-name      ${USERNAME}
    Input Text            id=password       ${PASSWORD}
    Click Button          id=login-button

    # กด ESC เผื่อมี popup ขึ้นหลัง login
    Sleep                 1s
    Press Keys            css=body    ESCAPE
    Sleep                 0.5s

    Wait Until Element Is Visible    class=inventory_list    timeout=10s

    # Step 2: เพิ่มสินค้าลงตะกร้า
    Click Button          xpath=//button[@data-test="add-to-cart-sauce-labs-backpack"]
    Wait Until Element Is Visible    xpath=//span[@class="shopping_cart_badge"]    timeout=5s

    # Step 3: ไปหน้า Cart
    Click Element         id=shopping_cart_container
    Wait Until Page Contains    Your Cart    timeout=10s

    # Step 4: กด Checkout
    Click Button          id=checkout

    # กด ESC เผื่อมี popup ขึ้นหลัง checkout
    Sleep                 1s
    Press Keys            css=body    ESCAPE
    Sleep                 0.5s

    Wait Until Page Contains    Checkout: Your Information    timeout=10s
    Sleep                 1s

    # Step 5: กรอกข้อมูลทุกช่อง
    Wait Until Element Is Visible    id=first-name    timeout=10s
    Click Element         id=first-name
    Input Text            id=first-name     ${FIRST_NAME}
    Sleep                 0.5s

    Click Element         id=last-name
    Input Text            id=last-name      ${LAST_NAME}
    Sleep                 0.5s

    Click Element         id=postal-code
    Input Text            id=postal-code    ${POSTAL_CODE}
    Sleep                 0.5s

    # Step 6: ตรวจสอบว่ากรอกครบทุกช่อง
    Textfield Value Should Be    id=first-name     ${FIRST_NAME}
    Textfield Value Should Be    id=last-name      ${LAST_NAME}
    Textfield Value Should Be    id=postal-code    ${POSTAL_CODE}
    Log               กรอกข้อมูลครบทุกช่องเรียบร้อย ✓