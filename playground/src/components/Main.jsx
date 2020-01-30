import React from "react";
import AppBar from "@material-ui/core/AppBar";
import Tab from "@material-ui/core/Tab";
import Tabs from "@material-ui/core/Tabs";

import TabPanel from "./TabPanel";
import QueryBrowser from "./QueryBrowser";
import styles from "../styles/main";



function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  };
}

export default function Main() {
  const classes = styles();

  const [value, setValue] = React.useState(0);

  const changeTab = (event, newValue) => {
    setValue(newValue);
  };

  return (
    <main className={classes.content}>
      <div className={classes.root}>
        <AppBar onChange={changeTab} position="static">
          <Tabs value={value} aria-label="simple tabs example">
            <Tab label="Query Browser" {...a11yProps(0)}/>
            <Tab label="Graph Viewer" {...a11yProps(1)} />
          </Tabs>
        </AppBar>
        <TabPanel value={value} index={0}>
          <QueryBrowser />
        </TabPanel>
        <TabPanel value={value} index={1}>
          Graph Viewer
        </TabPanel>
      </div>
    </main>
  );
}
