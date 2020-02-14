	function setupTypewriter(HTML, t) {
	    t.innerHTML = "";

	    var cursorPosition = 0,
	        tag = "",
	        writingTag = false,
	        tagOpen = false,
	        typeSpeed = 1,
        tempTypeSpeed = 0;


	    var type = function() {
        
	        if (writingTag === true) {
	            tag += HTML[cursorPosition];
	        }

	        if (HTML[cursorPosition] === "<") {
	            tempTypeSpeed = 0;
	            if (tagOpen) {
	                tagOpen = false;
	                writingTag = true;
	            } else {
	                tag = "";
	                tagOpen = true;
	                writingTag = true;
	                tag += HTML[cursorPosition];
	            }
	        }
	        if (!writingTag && tagOpen) {
	            tag.innerHTML += HTML[cursorPosition];
	        }
	        if (!writingTag && !tagOpen) {
	            if (HTML[cursorPosition] === " ") {
	                tempTypeSpeed = 0;
	            }
	            else {
	                tempTypeSpeed = (Math.random() * typeSpeed) + 0;
	            }
	            t.innerHTML += HTML[cursorPosition];
	        }
	        if (writingTag === true && HTML[cursorPosition] === ">") {
	            tempTypeSpeed = (Math.random() * typeSpeed) + 0;
	            writingTag = false;
	            if (tagOpen) {
	                var newSpan = document.createElement("span");
	                t.appendChild(newSpan);
	                newSpan.innerHTML = tag;
	                tag = newSpan.firstChild;
	            }
	        }

	        cursorPosition += 1;
	        if (cursorPosition < HTML.length - 1) {
	            setTimeout(type, tempTypeSpeed);
	        }

	    };

	    return {
	        type: type
	    };
	}