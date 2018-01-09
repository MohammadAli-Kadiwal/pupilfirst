import React from "react";

export default class CoderPassed extends React.Component {
  render() {
    return (
      <div>
        <p className="applicant-screening__quiz-result-text mb-2">
          <span className="font-semibold">
            You have cleared the screening process.
          </span>&nbsp; We encourage you to be on the lookout for co-founders
          who can compliment your skills. An ideal team would include
          co-founders who are good at design and product skills.
        </p>

        <p className="applicant-screening__quiz-result-text mb-3">
          Among our existing startups we have observed that teams with the above
          three skill sets make the most of our programme and deliver good
          results. You can now continue and add your team members. Good Luck!
        </p>
      </div>
    );
  }
}