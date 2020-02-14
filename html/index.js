var HTML;

function sliderUpdated(event,ui) {
}

function getSliderValues() {
	return {boost:$("#boost").slider("value"),fuelmix:$("#fuelmix").slider("value"),gearchange:$("#gearchange").slider("value"),braking:$("#braking").slider("value"),drivetrain:$("#drivetrain").slider("value"),brakeforce:$("#brakeforce").slider("value")};
}

function setSliderValues(values) {
	$(".slider").each(function(){
		if(values[this.id]!=null) {
			$(this).slider("value",values[this.id]);
		}
	});
	sliderUpdated();
}

function menuToggle(bool,send=false) {
	if(bool) {
		$("body").show();
	} else {
		$("body").hide();
	} 
	if(send){
		$.post('http://tunerchip/togglemenu', JSON.stringify({state:false}));
	}
}

$(function(){
	$("body").hide();
	$("#appName").text(Config.appName);
	$("#boost").slider({min:0.05,value:0.25,step:0.01,max:0.30,change:sliderUpdated});
	$("#fuelmix").slider({min:1,value:1.3,step:0.01,max:2,change:sliderUpdated});
	$("#gearchange").slider({min:1,value:12,max:50,step:12,change:sliderUpdated});
	$("#braking").slider({min:0.0,value:0.5,max:1,step:0.05,change:sliderUpdated});
	$("#drivetrain").slider({min:0.0,value:0.5,max:1,step:0.5,change:sliderUpdated});
	$("#brakeforce").slider({min:0.01,value:1.4,max:2,step:0.01,change:sliderUpdated});
	$("#defaultbtn").click(function(){setSliderValues({boost:0.25,fuelmix:1.3,gearchange:9,braking:0.5,drivetrain:0.5,brakeforce:1.4});});	
	$("#savebtn").click(function(){
		initiateTyepwriter();
		$.post('http://tunerchip/save', JSON.stringify(getSliderValues()));
	});
	$("#exitProgram").click(function(){
		menuToggle(false,true);
	});
	$("#shutDown").click(function(){
		menuToggle(false,true);
	});
	document.onkeyup = function (data) {
        if (data.which == 27) {
            menuToggle(false,true);
        }
    };
	window.addEventListener('message', function(event){
		if(event.data.type=="togglemenu") {
			menuToggle(event.data.state,false);
			if(event.data.data!=null) {
				setSliderValues(event.data.data);
			}
		}
	});
});

$(document).ready(function() {
	var typewriter = document.getElementById("typewriter");
	HTML = typewriter.innerHTML;
	
	typewriter.innerHTML = "";
	
});

function initiateTyepwriter() {
	var t = document.getElementById("typewriter");
	
	typewriter = setupTypewriter(HTML, t);
	typewriter.type();
	
	toggleButton(1);
	setTimeout(function() {toggleButton(0); }, 5000);
}

function toggleButton(bool) {
	var btnSave = document.getElementById("savebtn");
	btnSave.disabled = bool;
}