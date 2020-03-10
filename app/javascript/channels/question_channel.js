import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  var question_id = $('.question').data('id');

  if (question_id > 0) {
    if(this.subscription){
      consumer.subscriptions.remove(this.subscription);
    }
    var subscription = consumer.subscriptions.create( {channel: 'QuestionChannel', room: question_id }, {

      received(data) {
        if (data['event'] === 'new_answer' && data['question_author_id'] != gon.user_id) {
          var answers = $('.answers');
          if (answers) {
            var answer = renderAnswer(data['answer'], data['question_author_id']);
            var div = document.createElement('div');
            div.setAttribute('data-id', data['answer']['id']);
            div.setAttribute('id', "answer" + data['answer']['id']);
            div.classList.add('answer');
            div.innerHTML = answer;
            answers.append(div);
          }
        }
        if (data['event'] === 'new_comment'){
          var resource_type = data['resource_type'];

          if (resource_type === 'question') {
            var resource = $('.question-comments');
          }
          else if (resource_type === 'answer') {
            var resource = $('.answers div[data-id=' + data['resource_id'] + '] .answer-comments');
          };

          if ((resource) && (data['comment']['user_id'] != gon.user_id)) {
            var comment = renderComment(data['comment']);
            resource.append(comment);
          };
        }
      },
    });
    this.subscription = subscription;
  }

})

function renderAnswer(answer, question_author_id) {
  var renderBody = ``;

  renderBody += `
    <p>${answer['body']}</p>
  `;

  if (question_author_id == gon.user_id) {
    var setBestButton = `
      <a data-remote="true" rel="nofollow" data-method="patch" href="/answers/${answer['id']}/make_best">Make best answer</a>
    `;
    renderBody += setBestButton;
  };

  if (answer['user_id'] != gon.user_id && gon.user_id != null) {
    var votes = `
    <div class="vote-links">
      <a data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/${answer['id']}/upvote">Vote up</a>
      <a data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/${answer['id']}/downvote">Vote down</a>
      <a class="votecancel hidden" data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/${answer['id']}/votecancel">Cancel vote</a>
    </div>
    `;
    renderBody += votes;
  };

  renderBody += `
    <div class="answer-vote"><p class="counter">Votes: ${answer['counter']}</p></div>
  `;


  if (answer['user_id'] == gon.user_id) {
    var editLinks = `
      <a data-remote="true" rel="nofollow" data-method="delete" href="/answers/${answer['id']}">Delete</a>
    `;
    renderBody += editLinks;
  };


  var comments = `
    <div class="answer-comments">
      <h4>Comments:</h4>
    </div>
  `;

  renderBody += comments;

  return renderBody;
};

function renderComment(comment) {
  var body = `
  <div class="comment" data-id="${comment['id']}">
    <p>${comment['body']}</p> 
  `;

  body += '</div>'
  return body;
};
