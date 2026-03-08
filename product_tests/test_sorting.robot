*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Setup        Go To Products Page

*** Variables ***
${URL}           https://www.saucedemo.com/
${BROWSER}       chrome
${USERNAME}      standard_user
${PASSWORD}      secret_sauce
${DELAY}         0.3 seconds

*** Test Cases ***
Scenario: Sort Items By Name A To Z
    Select Sorting Option    az
    Verify Name Sorting    ascending

Scenario: Sort Items By Name Z To A
    Select Sorting Option    za
    Verify Name Sorting    descending

Scenario: Sort Items By Price Low To High
    Select Sorting Option    lohi
    Verify Price Sorting    ascending

Scenario: Sort Items By Price High To Low
    Select Sorting Option    hilo
    Verify Price Sorting    descending

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Login To Swag Labs

Login To Swag Labs
    Input Text        id:user-name    ${USERNAME}
    Input Password    id:password     ${PASSWORD}
    Click Button      id:login-button

Go To Products Page
    # เผื่อกรณีที่ Test Case ก่อนหน้าทำให้หน้าจอเปลี่ยนไป
    Go To    https://www.saucedemo.com/inventory.html
    Wait Until Element Is Visible    class:title

Select Sorting Option
    [Arguments]    ${value}
    Select From List By Value    class:product_sort_container    ${value}

Verify Name Sorting
    [Arguments]    ${order}
    ${elements}=    Get WebElements    class:inventory_item_name
    ${actual_names}=    Create List
    FOR    ${el}    IN    @{elements}
        ${text}=    Get Text    ${el}
        Append To List    ${actual_names}    ${text}
    END
    
    ${expected_names}=    Copy List    ${actual_names}
    IF    '${order}' == 'ascending'
        Sort List    ${expected_names}
    ELSE
        Sort List    ${expected_names}
        Reverse List    ${expected_names}
    END
    
    Lists Should Be Equal    ${actual_names}    ${expected_names}
    Log To Console    Name (${order}): ${actual_names}

Verify Price Sorting
    [Arguments]    ${order}
    ${elements}=    Get WebElements    class:inventory_item_price
    ${actual_prices}=    Create List
    FOR    ${el}    IN    @{elements}
        ${text}=    Get Text    ${el}
        ${price}=    Remove String    ${text}    $
        ${price_num}=    Convert To Number    ${price}
        Append To List    ${actual_prices}    ${price_num}
    END
    
    ${expected_prices}=    Copy List    ${actual_prices}
    IF    '${order}' == 'ascending'
        Sort List    ${expected_prices}
    ELSE
        Sort List    ${expected_prices}
        Reverse List    ${expected_prices}
    END
    
    Lists Should Be Equal    ${actual_prices}    ${expected_prices}
    Log To Console    Price (${order}): ${actual_prices}