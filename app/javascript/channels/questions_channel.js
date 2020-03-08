import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {},

  disconnected() {},

  received(data) {
    console.log('QuestionsChannel received', data);
    if(data['event'] == 'new_question') {
      var questionsDiv = $('.questions');
      if (questionsDiv) questionsDiv.append(data['data']);
    }
  },
});
