import React from "react";
import PropTypes from "prop-types";
import ReactDOM from "react-dom";
import WebpackerReact from "webpacker-react";
import Turbolinks from "turbolinks";

import helloIcon from "../iou/images/icon.png";
import styles from "../iou/styles/iou";

// import "material-design-lite/material.min.css";  // use custom colorered css from cdn instead
import "material-design-lite/material.min.js";
import "getmdl-select/getmdl-select.min.css";
import "getmdl-select/getmdl-select.min.js";

const Iou = props => (
  <div className={styles.iou}>
    <img src={helloIcon} alt="hello-icon" />
    <p>{props.description}!</p>
  </div>
);

Iou.defaultProps = {
  description: "some money"
};

Iou.propTypes = {
  description: PropTypes.string
};

WebpackerReact.setup({ Iou }); // Components that are registered like this are availabe in Rails Views
