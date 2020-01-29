import React from "react";
import { useTheme } from "@material-ui/core";
import ChevronLeftIcon from "@material-ui/icons/ChevronLeft";
import ChevronRightIcon from "@material-ui/icons/ChevronRight";
import Divider from "@material-ui/core/Divider";
import Drawer from "@material-ui/core/Drawer";
import IconButton from "@material-ui/core/IconButton";
import List from "@material-ui/core/List";
import ListItem from "@material-ui/core/ListItem";
import ListItemIcon from "@material-ui/core/ListItemIcon";
import ListItemText from "@material-ui/core/ListItemText";
import AccountCircle from "@material-ui/icons/AccountCircle";
import AccountTreeIcon from '@material-ui/icons/AccountTree';
import NotificationsIcon from "@material-ui/icons/Notifications";
import SettingsIcon from "@material-ui/icons/Settings";
import clsx from "clsx";
import { Icon } from "@iconify/react";
import graphqlIcon from "@iconify/icons-simple-icons/graphql";

import styles from "../styles/sidebar";

export default function MiniDrawer() {
  const classes = styles();
  const theme = useTheme();
  const [open, setOpen] = React.useState(false);

  const handleDrawerClose = () => {
    setOpen(false);
  };

  return (
    <Drawer
      variant="permanent"
      className={clsx(classes.drawer, {
        [classes.drawerOpen]: open,
        [classes.drawerClose]: !open
      })}
      classes={{
        paper: clsx({
          [classes.drawerOpen]: open,
          [classes.drawerClose]: !open
        })
      }}
    >
      <div className={classes.toolbar}>
        <IconButton onClick={handleDrawerClose}>
          {theme.direction === "rtl" ? (
            <ChevronRightIcon />
          ) : (
            <ChevronLeftIcon />
          )}
        </IconButton>
      </div>
      <Divider />
      <List>
        <ListItem button key="schema">
          <ListItemIcon>
            <Icon icon={graphqlIcon} width="24" height="24" />
          </ListItemIcon>
          <ListItemText primary="Schema" />
        </ListItem>
        <ListItem button key="types">
          <ListItemIcon>
            <AccountTreeIcon />
          </ListItemIcon>
          <ListItemText primary="Types" />
        </ListItem>
      </List>
      <Divider />
      <List>
        <ListItem button key="notifications">
          <ListItemIcon>
            <NotificationsIcon />
          </ListItemIcon>
          <ListItemText primary="Notifications" />
        </ListItem>
        <ListItem button key="settings">
          <ListItemIcon>
            <SettingsIcon />
          </ListItemIcon>
          <ListItemText primary="Settings" />
        </ListItem>
        <ListItem button key="account">
          <ListItemIcon>
            <AccountCircle />
          </ListItemIcon>
          <ListItemText primary="Account" />
        </ListItem>
      </List>
    </Drawer>
  );
}
