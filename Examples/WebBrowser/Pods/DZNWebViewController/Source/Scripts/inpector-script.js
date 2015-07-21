
var script = new function() {
    
    this.getElement = function(x,y) {
        var img = getImage(x,y);
        if (img == null) return getLink(x,y);
        else return img;
    }

    getLink = function(x,y) {
        var tags = "";
        var e = "";
        var offset = 0;
        while ((tags.length == 0) && (offset < 20)) {
            e = document.elementFromPoint(x,y+offset);
            while (e) {
                if (e.href) {
                    tags += e.href;
                    break;
                }
                e = e.parentNode;
            }
            if (tags.length == 0) {
                e = document.elementFromPoint(x,y-offset);
                while (e) {
                    if (e.href) {
                        tags += e.href;
                        break;
                    }
                    e = e.parentNode;
                }
            }
            offset++;
        }
        
        if (tags != null && tags.length > 0) return '{ "type" : "link" , "url" : "'+ tags +'", "title" : "'+ e.innerHTML +'"}';
        else return null;
    }
    
    getImage = function(x,y) {
        var tags = "";
        var title = "";
        var e = "";
        var offset = 0;
        while ((tags.length == 0) && (offset < 20)) {
            e = document.elementFromPoint(x,y+offset);
            while (e) {
                if (e.src) {
                    tags += e.src;
                    title += e.alt;
                    break;
                }
                e = e.parentNode;
            }
            if (tags.length == 0) {
                e = document.elementFromPoint(x,y-offset);
                while (e) {
                    if (e.src) {
                        tags += e.src;
                        title += e.alt;
                        break;
                    }
                    e = e.parentNode;
                }
            }
            offset++;
        }
        
        if (tags != null && tags.length > 0) return '{ "type" : "image" , "url" : "'+ tags +'" , "title" : "'+ title +'"}';
        else return null;
    }
}