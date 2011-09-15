(function() {
    var Dom = YAHOO.util.Dom,
        Event = YAHOO.util.Event;

    Event.onDOMReady(function() {
        var layout = new YAHOO.widget.Layout({
            units: [
                {
                    position: 'top',
                    height: 80, 
                    resize: false, 
                    gutter: '5px', 
                    collapse: true, 
                    resize: true,
                    body: 'top1'
                },
                {
                    position: 'left',
                    width: 120,
                    resize: true,
                    gutter: '5px',
                    collapse: true,
                    close: true,
                    collapseSize: 50,
                    scroll: true,
                    body: 'left1'
                },
                {
                    position: 'center',
                    body: 'center1',
                    scroll: true
                }
            ]
        });
        layout.render();
    });
})();

