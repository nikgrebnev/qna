$(document).on('turbolinks:load',function () {

    $('.question-vote').on('ajax:success', function(event) {
        var response = event.detail[0];
        $('.question-vote').find('.counter').html("Votes: " + response.counter);
        if(response.show_cancel_link == 'allow'){
            $('.question-vote').find('.voteup').addClass('hidden');
            $('.question-vote').find('.votedown').addClass('hidden');
            $('.question-vote').find('.votecancel').removeClass('hidden');
        }else{
            $('.question-vote').find('.voteup').removeClass('hidden');
            $('.question-vote').find('.votedown').removeClass('hidden');
            $('.question-vote').find('.votecancel').addClass('hidden');
        }
    });

    $('.answers').on('ajax:success', function(event) {
        var response = event.detail[0];
        var answerVote = "div[data-id='" + response.id + "']";
        $(answerVote).find('.counter').html("Votes: " + response.counter);
        if(response.show_cancel_link == 'allow'){
            $(answerVote).find('.voteup').addClass('hidden');
            $(answerVote).find('.votedown').addClass('hidden');
            $(answerVote).find('.votecancel').removeClass('hidden');
        }else{
            $(answerVote).find('.voteup').removeClass('hidden');
            $(answerVote).find('.votedown').removeClass('hidden');
            $(answerVote).find('.votecancel').addClass('hidden');
        }
    });
});
