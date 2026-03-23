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

*** Keywords ***
Open Chrome With Options
    ${chrome_options}=    Evaluate
    ...    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    &{prefs}=             Create Dictionary    profile.password_manager_leak_detection=${False}
    Call Method           ${chrome_options}    add_experimental_option    prefs    ${prefs}
    Open Browser          ${BASE_URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window
    Sleep                 1s

Login And Go To Checkout
    Go To             ${BASE_URL}
    Input Text        id=user-name      ${USERNAME}
    Input Text        id=password       ${PASSWORD}
    Click Button      id=login-button
    Wait Until Element Is Visible    class=inventory_list    timeout=10s
    Click Button      xpath=//button[@data-test="add-to-cart-sauce-labs-backpack"]
    Wait Until Element Is Visible    xpath=//span[@class="shopping_cart_badge"]    timeout=5s
    Click Element     id=shopping_cart_container
    Wait Until Page Contains    Your Cart    timeout=10s
    Click Button      id=checkout
    Wait Until Page Contains    Checkout: Your Information    timeout=10s

*** Test Cases ***
Case 1: ไม่กรอกข้อมูลเลยทุกช่อง
    [Documentation]    ไม่กรอกข้อมูลทุกช่อง แล้วกด Continue
    Open Chrome With Options
    Login And Go To Checkout
    Click Button      id=continue
    Wait Until Element Is Visible    xpath=//h3[@data-test="error"]    timeout=5s
    Element Text Should Be    xpath=//h3[@data-test="error"]    Error: First Name is required
    Log               ✓ แสดง Error: First Name is required
    Close Browser

Case 2: กรอกแค่ First Name
    [Documentation]    กรอกเฉพาะ First Name ไม่กรอก Last Name และ Postal Code
    Open Chrome With Options
    Login And Go To Checkout
    Input Text        id=first-name     ${FIRST_NAME}
    Click Button      id=continue
    Wait Until Element Is Visible    xpath=//h3[@data-test="error"]    timeout=5s
    Element Text Should Be    xpath=//h3[@data-test="error"]    Error: Last Name is required
    Log               ✓ แสดง Error: Last Name is required
    Close Browser

Case 3: กรอกแค่ Last Name
    [Documentation]    กรอกเฉพาะ Last Name ไม่กรอก First Name และ Postal Code
    Open Chrome With Options
    Login And Go To Checkout
    Input Text        id=last-name      ${LAST_NAME}
    Click Button      id=continue
    Wait Until Element Is Visible    xpath=//h3[@data-test="error"]    timeout=5s
    Element Text Should Be    xpath=//h3[@data-test="error"]    Error: First Name is required
    Log               ✓ แสดง Error: First Name is required
    Close Browser

Case 4: กรอกแค่ Postal Code
    [Documentation]    กรอกเฉพาะ Postal Code ไม่กรอก First Name และ Last Name
    Open Chrome With Options
    Login And Go To Checkout
    Input Text        id=postal-code    ${POSTAL_CODE}
    Click Button      id=continue
    Wait Until Element Is Visible    xpath=//h3[@data-test="error"]    timeout=5s
    Element Text Should Be    xpath=//h3[@data-test="error"]    Error: First Name is required
    Log               ✓ แสดง Error: First Name is required
    Close Browser

Case 5: กรอก First Name และ Last Name ไม่กรอก Postal Code
    [Documentation]    กรอก First Name และ Last Name แต่ไม่กรอก Postal Code
    Open Chrome With Options
    Login And Go To Checkout
    Input Text        id=first-name     ${FIRST_NAME}
    Input Text        id=last-name      ${LAST_NAME}
    Click Button      id=continue
    Wait Until Element Is Visible    xpath=//h3[@data-test="error"]    timeout=5s
    Element Text Should Be    xpath=//h3[@data-test="error"]    Error: Postal Code is required
    Log               ✓ แสดง Error: Postal Code is required
    Close Browser

Case 6: กรอก First Name และ Postal Code ไม่กรอก Last Name
    [Documentation]    กรอก First Name และ Postal Code แต่ไม่กรอก Last Name
    Open Chrome With Options
    Login And Go To Checkout
    Input Text        id=first-name     ${FIRST_NAME}
    Input Text        id=postal-code    ${POSTAL_CODE}
    Click Button      id=continue
    Wait Until Element Is Visible    xpath=//h3[@data-test="error"]    timeout=5s
    Element Text Should Be    xpath=//h3[@data-test="error"]    Error: Last Name is required
    Log               ✓ แสดง Error: Last Name is required
    Close Browser

Case 7: กรอก Last Name และ Postal Code ไม่กรอก First Name
    [Documentation]    กรอก Last Name และ Postal Code แต่ไม่กรอก First Name
    Open Chrome With Options
    Login And Go To Checkout
    Input Text        id=last-name      ${LAST_NAME}
    Input Text        id=postal-code    ${POSTAL_CODE}
    Click Button      id=continue
    Wait Until Element Is Visible    xpath=//h3[@data-test="error"]    timeout=5s
    Element Text Should Be    xpath=//h3[@data-test="error"]    Error: First Name is required
    Log               ✓ แสดง Error: First Name is required
    Close Browser