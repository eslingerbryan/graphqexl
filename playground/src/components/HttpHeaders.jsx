import React from "react";
import TextField from "@material-ui/core/TextField";
import styles from "../styles/main";

export default class HttpHeaders extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      headers: [],
    }

  }
  render() {
    const classes = styles();

    return(
      <form className={classes.root} noValidate autoComplete="off">
        <TextField id="header1" label="header" />
        <TextField id="value1" label="value" />

        <TextField id="header1" label="header" />
        <TextField id="value1" label="value" />
      </form>
    )
  }
}
