import React from "react";
import Grid from "@material-ui/core/Grid";
import Paper from "@material-ui/core/Paper";
import Typography from "@material-ui/core/Typography";

import HttpHeaders from "./HttpHeaders";
import QueryEditor from "./QueryEditor";
import styles from "../styles/main";

export default function QueryBrowser() {
  const classes = styles();

  return (
    <Grid
      container
      direction="row"
      justify="center"
      alignItems="center"
      spacing={3}
    >
      <Grid item xs={12}>
        <Paper className={classes.paper} style={{ height: "429px" }}>
          <Typography
            className={classes.title}
            variant="h4"
            id="query-browser"
          >
            <p style={{ padding: "15px 0 0 15px" }}>Query Browser</p>
          </Typography>

          <QueryEditor />
        </Paper>
      </Grid>
      <Grid item xs={12}>
        <Paper className={classes.paper} style={{ height: "429px" }}>
          <Typography
            className={classes.title}
            variant="h4"
            id="tableTitle"
          >
            <p style={{ padding: "15px 0 0 15px" }}>HTTP Headers</p>
          </Typography>

          <HttpHeaders />
        </Paper>
      </Grid>
    </Grid>
  )
}
