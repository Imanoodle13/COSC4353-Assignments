function eventSimilarityRatio(eventSkills = [], volunteerSkills = []) {
    const sortedEvent = [...eventSkills].sort();
    const sortedVol = [...volunteerSkills].sort();

    let matchCount = 0;
    for (const v of sortedVol) {
        if (sortedEvent.includes(v)) matchCount++;
    }

    const ratio = eventSkills.length
        ? matchCount / eventSkills.length
        : 0;
    return { matchCount, ratio };
}

module.exports = { eventSimilarityRatio };