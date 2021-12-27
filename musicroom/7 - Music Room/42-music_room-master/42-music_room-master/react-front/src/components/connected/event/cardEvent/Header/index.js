import React, { Component } from 'react';
import { Card } from 'antd';
import './styles.css';

export default class CardHeader extends Component {
	constructor(props) {
        super(props);
        this.gridStylePicture = {
                width       : '50%',
                boxShadow   : '1px 0 0 0',
                padding     : '0 0 0 0',
                textAlign   :  'center',
        };
        this.gridStyleBlack = {
            width           : '25%',
            boxShadow       : '1px 0 0 0',
            padding         : '0 0 0 0',
            minHeight       : '400px',
            textAlign       : 'center',
            backgroundColor : 'black'
        };
    }
	render() {
        return (
            <div className="HeaderMarge headerContent">
                <Card>
                    <Card.Grid style={this.gridStyleBlack}/>
                    <Card.Grid style={this.gridStylePicture}>
                        <img 
                            className="Image" 
                            alt="eventPicture" 
                            src={process.env.REACT_APP_API_URL + "/eventPicture/" + this.props.state.data.event.picture} 
                        />
                        <div className="CenterTitle"> 
                            <h1 className="Title">  
                            {
                                this.props.state.data.event.title ? 
                                    this.props.state.data.event.title[0].toUpperCase() + this.props.state.data.event.title.slice(1) 
                                    : 
                                    "Aucun"
                            } 
                            </h1> 
                        </div>
                    </Card.Grid>
                    <Card.Grid style={this.gridStyleBlack}/>
                    
                </Card>
            </div>
        );
  }
}

