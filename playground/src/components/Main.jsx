import React from "react";
import AppBar from "@material-ui/core/AppBar";
import Tab from "@material-ui/core/Tab";
import TabPanel from "@material-ui/core/Tabs";
import Tabs from "@material-ui/core/Tabs";

import QueryBrowser from "./QueryBrowser";
import styles from "../styles/main";

export default function Main() {
  const classes = styles();

  return (
    <main className={classes.content}>
      <AppBar position="static">
        <Tabs value={0} aria-label="simple tabs example">
          <Tab label="Query Browser" />
          <Tab label="Graph Viewer" />
        </Tabs>
      </AppBar>
      <TabPanel value={0} index={0}>
        <QueryBrowser />
      </TabPanel>
      <TabPanel value={0} index={1}>
        Graph Viewer
      </TabPanel>
    </main>
  );
}
