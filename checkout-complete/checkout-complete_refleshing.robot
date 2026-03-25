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
    click button    id=finish
    Wait Until Page Contains    Checkout: Complete!    timeout=10s
    ${before_url}=    Get Location
    Reload Page
    Wait Until Location Is    ${before_url}    10s
    Location Should Be        ${before_url}


