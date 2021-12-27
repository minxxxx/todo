import React, { Component } from 'react';
import { BrowserRouter as Router , Route } from 'react-router-dom';
import Confirm from './components/other/confirm'
import Front from './components'

class App extends Component {

  render() {
    return (
        <Router>
          <div>
          <Route path="/user/confirm/:token" component={Confirm} />
          <Route path="/" component={Front} />
          </div>
        </Router>
    );
  }
}

export default App;
