import React from "react";
import Typography from "@material-ui/core/Typography";

import styles from "../styles/main";

export default function QueryResult() {
  const classes = styles();

  return(
    <Typography className={classes.title} variant="h5">Query Result</Typography>
  )
}
