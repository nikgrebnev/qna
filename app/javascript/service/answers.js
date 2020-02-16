$(document).on('turbolinks:load',function () {

    $('.answers').on('click', '.make-best-answer-link', function(event) {
        event.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden')
    })

    $('.answers').on('click', '.edit-answer-link', function(event) {
        event.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden')
    })
});
