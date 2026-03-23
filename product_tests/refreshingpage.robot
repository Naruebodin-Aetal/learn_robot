*** Settings ***
Library           SeleniumLibrary

Suite Setup       Open Browser    ${BASE_URL}    ${BROWSER}
                  AND   Maximize Browser Window
Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}       https://www.saucedemo.com
${BROWSER}        chrome
${USERNAME}       standard_user
${PASSWORD}       secret_sauce

*** Test Cases ***
Add Product To Cart And Refresh
    [Documentation]    1. เพิ่มสินค้าลงตะกร้า  2. ไปหน้า Cart  3. รีเฟรชหน้า

    # Step 0: Login ก่อน
    Go To             ${BASE_URL}
    Input Text        id=user-name      ${USERNAME}
    Input Text        id=password       ${PASSWORD}
    Click Button      id=login-button
    Wait Until Element Is Visible    class=inventory_list    timeout=10s

    # Step 1: เพิ่มสินค้าลงตะกร้า
    Click Button      xpath=//button[@data-test="add-to-cart-sauce-labs-backpack"]
    Wait Until Element Is Visible    xpath=//span[@class="shopping_cart_badge"]    timeout=5s
    Log               เพิ่มสินค้า "Sauce Labs Backpack" ลงตะกร้าแล้ว

    # Step 2: ไปหน้า Cart
    Click Element     id=shopping_cart_container
    Wait Until Page Contains    Your Cart    timeout=10s
    Location Should Contain     /cart.html
    Log               อยู่ที่หน้า Cart แล้ว

    # Step 3: รีเฟรชหน้า
    Reload Page
    Wait Until Page Contains    Your Cart    timeout=10s
    Log               รีเฟรชหน้าเรียบร้อยแล้ว

    # ตรวจสอบว่าสินค้ายังอยู่ในตะกร้าหลังรีเฟรช
    Page Should Contain    Sauce Labs Backpack
    Log               สินค้ายังคงอยู่ในตะกร้าหลังรีเฟรช ✓