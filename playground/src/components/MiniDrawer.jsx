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
import CodeIcon from '@material-ui/icons/Code';
import DescriptionIcon from '@material-ui/icons/Description';
import FileCopyIcon from '@material-ui/icons/FileCopy';
import HelpIcon from '@material-ui/icons/Help';
import ListAltIcon from '@material-ui/icons/ListAlt';
import NotificationsIcon from "@material-ui/icons/Notifications";
import PlaylistPlayIcon from '@material-ui/icons/PlaylistPlay';
import SettingsIcon from "@material-ui/icons/Settings";
import SubscriptionsIcon from '@material-ui/icons/Subscriptions';
import WarningIcon from '@material-ui/icons/Warning';
import clsx from "clsx";
import { Icon } from "@iconify/react";
import graphqlIcon from "@iconify/icons-simple-icons/graphql";

import styles from "../styles/sidebar";
import schema from "../testSchema";

export default function MiniDrawer() {
  const classes = styles();
  const theme = useTheme();
  const [open, setOpen] = React.useState(false);

  const handleDrawerClose = () => {
    setOpen(false);
  };

  const iconForType = (type) => {
    switch(type) {
      case "enum":
        return ListAltIcon;
      case "interface":
        return FileCopyIcon;
      case "type":
        return DescriptionIcon;
      case "union":
        return PlaylistPlayIcon;
      default:
        return HelpIcon;
    }
  };

  const renderMutations = (mutations) => {
    return (
      <List>
        {mutations.map(mutation=> {
          return (
            <ListItem button key={mutation.name.toLowerCase()}>
              <ListItemIcon><WarningIcon/></ListItemIcon>
              <ListItemText primary={mutation.name} />
            </ListItem>
          )
        })

        }
      </List>
    )
  };

  const renderQueries = (queries) => {
    return (
      <List>
        {queries.map(query => {
          return (
            <ListItem button key={query.name.toLowerCase()}>
              <ListItemIcon><CodeIcon/></ListItemIcon>
              <ListItemText primary={query.name} />
            </ListItem>
          )
        })

        }
      </List>
    )
  };

  const renderSubscriptions = (subscriptions) => {
    return (
      <List>
        {subscriptions.map(subscription => {
          return (
            <ListItem button key={subscription.name.toLowerCase()}>
              <ListItemIcon><SubscriptionsIcon/></ListItemIcon>
              <ListItemText primary={subscription.name} />
            </ListItem>
          )
        })

        }
      </List>
    )
  };

  const renderTypes = (types) => {
    return (
      <List>
        {types.map(type => {
          const TypeIcon = iconForType(type.type);
          return (
            <ListItem button key={type.name.toLowerCase()}>
              <ListItemIcon>
                <TypeIcon />
              </ListItemIcon>
              <ListItemText primary={type.name} />
            </ListItem>
          );
        })}
      </List>
    )
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
          <ListItemText primary="Query Browser" />
        </ListItem>
      </List>
      <Divider />
      <List>
        <ListItem button key="schema">
          <ListItemIcon>
            <AccountTreeIcon />
          </ListItemIcon>
          <ListItemText primary="Schema" />
        </ListItem>
        <ListItem button key="types">
          <ListItemIcon>
            <FileCopyIcon />
          </ListItemIcon>
          <ListItemText primary="Types" />
        </ListItem>
        <ListItem button key="queries">
          <ListItemIcon>
            <CodeIcon />
          </ListItemIcon>
          <ListItemText primary="Queries" />
        </ListItem>
        <ListItem button key="mutations">
          <ListItemIcon>
            <WarningIcon/>
          </ListItemIcon>
          <ListItemText primary="Mutations" />
        </ListItem>
        <ListItem button key="subscriptions">
          <ListItemIcon>
            <PlaylistPlayIcon />
          </ListItemIcon>
          <ListItemText primary="Subscriptions" />
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
