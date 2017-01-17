# check_http_win
(Very!) Simple check_http alternative running on Windows hosts

Usage 
---

    cscript check_http_win.vbs GET https://www.claudiokuenzler.com "" ""
    HTTP OK - https://www.claudiokuenzler.com returns 200
    
    cscript check_http_win.vbs GET https://www.claudiokuenzler.com/glerqlewsd "" ""
    HTTP WARNING - http://www.claudiokuenzler.com/test returns 404
    
    script check_http_win.vbs GET https://www.claudiokuenzler.com/glerqlewsd 404 ""
    HTTP OK - http://www.claudiokuenzler.com/test returns 404 (expected: 404)
