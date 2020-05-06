*** Settings ***
Library         SeleniumLibrary    15    10
Library         OperatingSystem
#Library         RequestsLibrary
#Library         Collections
Suite Setup    SuiteSetup
Suite Teardown    Close All Browsers

*** Variables ***
${TARGET}    https://www.ted.com/talks/patrick_mcginnis_how_to_make_faster_decisions?language=en
${playBtn}    //*[@title="play video"]//span
${playReady}    //div[@class="play-pulse"]
${stayPoint}    //button[@aria-label="Pause Video"]
${targetText}    //*[@style="transform: translateY(-3rem);"]/div/div/span

*** Test Cases ***
Get text for learning video
    [Tags]    only_one
    Wait Until Element Is Visible    ${playReady}
    Click Element    ${playBtn}
    Mouse Over    ${stayPoint}
    :FOR    ${limit}    IN RANGE    9999
    \    Wait Until Page Contains Element    ${targetText}
    \    ${text} =    Get Text    ${targetText}
    \    Run Keyword If    "${text}" != ""    Append To File    temp_file/temps.txt    ${text}
    \    Wait Until Page Does Not Contain    ${text}

*** Keywords ***
SuiteSetup
    ${workDir} =    Evaluate    os.getcwd()    os
    Set Suite Variable    ${WORKDIR}    ${workDir}
    ${options} =    Evaluate  sys.modules['selenium.webdriver.chrome.options'].Options()    sys
    Call Method     ${options}    add_argument    --disable-notifications
    ${myOS} =    Evaluate    platform.system()    platform
    Run Keyword If    '${myOS}' == 'Windows'
    ...    Set Suite Variable    ${chromedriverPath}    ${WORKDIR}/chromedriver_win.exe
    Run Keyword If    '${myOS}' == 'Linux'
    ...    Set Suite Variable    ${chromedriverPath}    ${WORKDIR}/chromedriver_linux
    ${driver}=    Create Webdriver    Chrome    options=${options}    executable_path=${chromedriverPath}
    Go To     ${TARGET}
