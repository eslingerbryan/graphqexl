import React from "react";
import Divider from "@material-ui/core/Divider";
import Grid from "@material-ui/core/Grid";
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
        <Grid container direction="row" spacing={3}>
          <Grid item xs={3}>
            <TextField id="header1" label="header" />
          </Grid>
          <Grid item xs={9}>
            <TextField id="value1" label="value" />
          </Grid>
          <Divider />
          <Grid item xs={3}>
            <TextField id="header2" label="header" />
          </Grid>
          <Grid item xs={9}>
            <TextField id="value2" label="value" />
          </Grid>
        </Grid>
      </form>
    )
  }
}
