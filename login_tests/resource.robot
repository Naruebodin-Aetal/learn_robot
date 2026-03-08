*** Settings ***
Documentation     A resource file with reusable keywords and variables.
Library           SeleniumLibrary

*** Variables ***
${SERVER}             saucedemo.com
${BROWSER}            Chrome
${VALID USER}         standard_user
${VALID PASSWORD}     secret_sauce
${LOGIN URL}          https://www.${SERVER}
${WELCOME URL}        https://www.${SERVER}/inventory.html
${ERROR URL}          https://www.${SERVER}

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Maximize Browser Window
    Login Page Should Be Open

Login Page Should Be Open
    Title Should Be    Swag Labs
    Wait Until Page Contains Element    id=user-name    10s

Go To Login Page
    Go To    ${LOGIN URL}
    Login Page Should Be Open

Input Username
    [Arguments]    ${username}
    Input Text    id=user-name    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    id=password    ${password}

Submit Credentials
    Click Button    id=login-button

Welcome Page Should Be Open
    Wait Until Location Contains    /inventory.html    10s
    Location Should Be    ${WELCOME URL}
    Title Should Be    Swag Labs

Login Should Have Failed
    # ใช้อย่างใดอย่างหนึ่งก็ได้ (หรือทั้งคู่)
    Wait Until Location Is          ${ERROR URL}    10s
    Wait Until Page Contains Element    css=[data-test="error"]    10s