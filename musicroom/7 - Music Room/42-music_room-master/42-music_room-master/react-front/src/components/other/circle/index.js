import React, { Component } from 'react';
import './styles.css'


class App extends Component {
	constructor(props) {
		super(props);
		this.state = {
    }
    
}


  render() {
    return (
        <div className="container">
        
            <h1>Pulse Animation</h1>
            
            <svg className="pulse" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg">
                <circle id="Oval" cx="512" cy="512" r="512"></circle>
                <circle id="Oval" cx="512" cy="512" r="512"></circle>
                <circle id="Oval" cx="512" cy="512" r="512"></circle>
            </svg>
        </div> 
    );
  }
}

export default App;
