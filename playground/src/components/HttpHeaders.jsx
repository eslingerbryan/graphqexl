import React from "react";
import Divider from "@material-ui/core/Divider"
import TextField from "@material-ui/core/TextField";

export default class HttpHeaders extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      headers: [],
    }

  }
  render() {

    return(
      <form noValidate autoComplete="off">
        <TextField id="header1" label="header" />
        <TextField id="value1" label="value" />
        <Divider />
        <TextField id="header1" label="header" />
        <TextField id="value1" label="value" />
      </form>
    )
  }
}
