import React, { Component } from 'react';
import axios from 'axios'
import { Redirect } from 'react-router-dom'
import { message } from 'antd'

class Confirm extends Component {
    constructor(props) {
        super(props);
        this.state = {
            redirect: false
          }
    }
    
    componentWillMount = () => {
        axios.put(process.env.REACT_APP_API_URL + '/user/confirm',{}, {'headers':{'Authorization': 'Bearer ' + this.props.match.params.token}})
		.then((resp) => {
			message.success("Mail confirmed")
			this.setState({redirect: true});
		})
		.catch((err) => {
			message.error("Error Sending mail")
            console.log(err);
            this.setState({redirect: true});
		})
    }

    renderRedirect = () => {
        if (this.state.redirect) {
          return <Redirect to='/' />
        }
      }

	render() {
		return (
            <div>
                {this.renderRedirect()}
            </div>
        );
	}
}

export default Confirm;
