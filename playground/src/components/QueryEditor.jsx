import React from "react";
import Fab from "@material-ui/core/Fab";
import TextareaAutosize from "@material-ui/core/TextareaAutosize";
import SendIcon from "@material-ui/icons/Send";

export default class QueryEditor extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      code: `query getSinglePost($postId: "foo") {
  getPost(id: $postId) {
    title
    text
    author {
      # comment can be anywhere
      firstName
      lastName
    }
    comments {
      author {
        firstName
        lastName
      }
      text
    }
  }
}
      `,
    }
  }
  render() {
    const {code} = this.state;

    return (
      <div id="query-editor">
        <TextareaAutosize
          defaultValue="Start typing your query..."
          inputProps={{ 'aria-label': 'description' }}
          value={code}
          rowsMin={10}
          style={{width:"67%"}}
        />
        <Fab
          style={{position: "absolute", right: "2", bottom: "2"}}
          color="secondary"
          aria-label="edit"
        >
          <SendIcon />
        </Fab>
      </div>
    );
  }
}
