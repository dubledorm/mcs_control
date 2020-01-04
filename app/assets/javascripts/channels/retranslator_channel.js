//import consumer from "../consumer"

// App.cable.subscriptions.create("RetranslatorChannel", {
//   connected() {
//     // Called when the subscription is ready for use on the server
//   },
//
//   disconnected() {
//     // Called when the subscription has been terminated by the server
//   },
//
//   received(data) {
//     // Called when there's incoming data on the websocket for this channel
//   },
//
//   trace: function() {
//     return this.perform('trace');
//   }
// });


$(function() {
    $('[data-channel-subscribe="Retranslator"]').each(function(index, element) {
        var $element = $(element),
            room_id = $element.data('room-id')
        messageTemplate = $('[data-role="message-template"]');

        $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000)

        App.cable.subscriptions.create(
            {
                channel: "Retranslator",
                room: "3001"
            },
            {
                received: function(data) {
                    var content = messageTemplate.children().clone(true, true);
                   // content.find('[data-role="user-avatar"]').attr('src', data.user_avatar_url);
                    content.find('[data-role="message-text"]').text(data.message);
                   // content.find('[data-role="message-date"]').text(data.updated_at);
                    $element.append(content);
                    $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000);
                }
            }
        );
    });
});