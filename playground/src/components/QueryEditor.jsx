import React from "react";
import Editor from "./QueryBrowser";
import Prism from "prismjs";
import "prismjs/components/prism-clike";
import "prismjs/components/prism-javascript";

class QueryEditor extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      code: `function add(a, b) {
        return a + b;
      }`

    }
  }
  render() {
    return (
      <Editor
        value={this.state.code}
        onValueChange={code => this.setState({ code })}
        highlight={code => Prism.highlight(code, Prism.languages.graphql, 'graphql')}
        padding={10}
        style={{
          fontFamily: '"Fira code", "Fira Mono", monospace',
          fontSize: 12,
        }}
      />
    );
  }
}

export default QueryEditor;
