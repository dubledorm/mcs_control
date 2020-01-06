$(function() {
    $('[data-channel-subscribe="Retranslator"]').each(function(index, element) {
        var $element = $(element),
            retr_id = $element.data('retr-id');
        terminalBox = $('[data-role="message-template"]')
        rowsContainer = $('[data-role="rows-container"]');

        $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000)

        App.cable.subscriptions.create(
            {
                channel: "RetranslatorChannel",
                retranslator: retr_id
            },
            {
                received: function(data) {
                    let content = rowsContainer.children()[0].cloneNode(true)

                    content.textContent = data;
                    rowsContainer.append(content);
                    if (rowsContainer.children().length > 1000) {
                        rowsContainer.children()[0].remove()
                    }

                    terminalBox.animate({ scrollTop: terminalBox.prop("scrollHeight")}, 1000);
                }
            }
        );
    });
});