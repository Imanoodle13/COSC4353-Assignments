const test = require('ava');
const { eventSimilarityRatio } = require('../match.js');

test('perfect match', t => {
    const event = ['A','B','C'];
    const volunteer = ['A','B','C'];
    const { matchCount, ratio } = eventSimilarityRatio(event, volunteer);
    t.is(matchCount, 3);
    t.is(ratio, 1);
});

test('partial match', t => {
    const event = ['JavaScript','Node','SQL'];
    const volunteer = ['JS','Node','SQL'];
    const { matchCount, ratio } = eventSimilarityRatio(event, volunteer);
    t.is(matchCount, 2);
    t.is(ratio, 2/3);
});

test('no match', t => {
    const { matchCount, ratio } = eventSimilarityRatio(['A'], ['B']);
    t.is(matchCount, 0);
    t.is(ratio, 0);
});