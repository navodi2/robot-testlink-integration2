*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser    https://practicetestautomation.com/practice-test-login/    headlesschrome

Suite Teardown    Close Browser

*** Variables ***
${VALID_USER}    student
${VALID_PASS}    Password123
${INVALID_USER}  wronguser
${INVALID_PASS}  wrongpass

*** Test Cases ***

TC-1001 Verify successful login with valid credentials
    Wait Until Element Is Visible    id=username    10s
    Input Text    id=username    ${VALID_USER}
    Input Text    id=password    ${VALID_PASS}
    Click Button    id=submit
    Page Should Contain    Logged In Successfully

TC-1002 Verify login fails with invalid username or password
    Input Text    id=username    ${INVALID_USER}
    Input Text    id=password    ${INVALID_PASS}
    Click Button    id=submit
    Page Should Contain    Your username is invalid!

TC-1003 Verify login fails with empty username or password
    Input Text    id=username
    Input Text    id=password
    Click Button    id=submit
    Page Should Contain    Both fields are required

TC-1004 Verify Forgot Password functionality works correctly
    Click Link    xpath=//a[contains(text(),'Forgot your password?')]
    Page Should Contain    Enter your email to reset password

TC-1005 Verify session expires after inactivity
    Input Text    id=username    ${VALID_USER}
    Input Text    id=password    ${VALID_PASS}
    Click Button    id=submit
    Sleep    10 seconds
    Reload Page
    Page Should Contain    Please log in again
