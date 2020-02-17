$(document).on('turbolinks:load',function () {

    $('.question-vote').on('ajax:success', function(event) {
        var response = event.detail[0];
        $('.question-vote').find('.counter').html("Votes: " + response.votes_rate);
        if(response.show_cancel_link == 'allow'){
            $('.question-vote').find('.vote-links').addClass('hidden');
            $('.question-vote').find('.votecancel').removeClass('hidden');
        }else{
            $('.question-vote').find('.vote-links').removeClass('hidden');
            $('.question-vote').find('.votecancel').addClass('hidden');
        }
    });

    $('.answers').on('ajax:success', function(event) {
        var response = event.detail[0];
        var answerVote = "div[data-id='" + response.id + "']";
        $(answerVote).find('.counter').html("Votes: " + response.votes_rate);
        if(response.show_cancel_link == 'allow'){
            $(answerVote).find('.vote-links').addClass('hidden');
            $(answerVote).find('.votecancel').removeClass('hidden');
        }else{
            $(answerVote).find('.vote-links').removeClass('hidden');
            $(answerVote).find('.votecancel').addClass('hidden');
        }
    });
});
