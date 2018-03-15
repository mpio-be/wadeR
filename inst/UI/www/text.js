window.pressed = function(){
        var a = document.getElementById('fileIn');
        if(a.value === "")
        {
            noFile.innerHTML = "Select ONLY directory Garmin within your  e.g. E: GARMIN";
        }
        else
        {
            noFile.innerHTML = "";
        }
    };