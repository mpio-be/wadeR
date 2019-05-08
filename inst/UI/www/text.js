window.pressed = function(){
        var a = document.getElementById('fileIn');
        if(a.value === "")
        {
            noFile.innerHTML = "Select ONLY the Garmin directory!";
        }
        else
        {
            noFile.innerHTML = "";
        }
    };