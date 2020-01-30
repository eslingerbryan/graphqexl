import React from "react";
import CssBaseline from "@material-ui/core/CssBaseline";

import Header from "./components/Header";
import Main from "./components/Main";
import MiniDrawer from "./components/MiniDrawer";

export default function App() {
  return (
    <div>
      <Header />
      <CssBaseline />
      <MiniDrawer />
      <Main />
    </div>
  );
}
