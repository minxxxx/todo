import React, { Component } from 'react';
import { Layout, Row, Col, Divider, Spin } from 'antd';
import axios from 'axios'
import PreviewCard from '../previewCardEvent'
import List from '../listEvent'
import Map from '../map'
import Error from '../../../other/errorController'

export default class listCloseEvent extends Component {
	constructor(props) {
        super(props);
        this.state = {
            events: [],
            loading: true,
            displayCard:false,
            currentEvent: {}
        };
    }
    componentWillMount = () => {
        window.scrollTo(700, 700);
        axios.get(process.env.REACT_APP_API_URL + '/event', {'headers':{'Authorization': 'Bearer '+ localStorage.getItem('token')}})
		.then((resp) => {
            let result = [];
            if (resp.data.myEvents && resp.data.myEvents.length !== 0)
                result = result.concat(resp.data.myEvents)
            if (resp.data.friendEvent && resp.data.friendEvent.length !== 0)
                result = result.concat(resp.data.friendEvent)
            if (resp.data.allEvents && resp.data.allEvents.length !== 0)
                result = result.concat(resp.data.allEvents)
            this.setState({events: result.reverse()}, () => {
                this.setState({loading:false});
            });
		})
		.catch((err) => { Error.display_error(err); });
    }
    updateCurrentEvent = event => {
        this.setState({currentEvent:event, displayCard:true});
    }
	render() {
		if (this.state.loading)
			return <Spin tip=" Waiting events ..." size="large" > </Spin>
        else {
            return (
                <div>
                    <Row> 
                        <Col span={8}> 
                            <a 
                                href="#!" 
                                className="btn waves-effect waves-teal" 
                                onClick={() => this.props.changeView('listEvent')}
                            >
                                Back
                            </a> 
                        </Col> 
                    </Row>
                    <Divider />
                    <Layout>
                        <Layout.Content>
                            <Row style={{height:'800px'}}>
                                <Col span={14} offset={2}>
                                    { 
                                        this.state.loading === false  ? 
                                            <div style={{height:'650px', margin:'5% 0 0 0'}}>
                                                <Map 
                                                    updateCurrentEvent={this.updateCurrentEvent} 
                                                    state={this.props.state} 
                                                    events={this.state.events}
                                                /> 
                                            </div>
                                            :
                                            null
                                    }
                                </Col>
                                <Col span={6} offset={2}>
                                    { 
                                        this.state.displayCard === true ? 
                                            <div style={{margin:'20% 0 0 0'}}> 
                                                <PreviewCard 
                                                    event={this.state.currentEvent} 
                                                    state={this.props.state}
                                                    openCardEvent={this.props.openCardEvent} 
                                                    updateParent={this.props.updateParent}
                                                />
                                            </div> 
                                            : 
                                            null 
                                    }
                                </Col>
                            </Row>
                            <Divider />
                            <List 
                                state={this.props.state} 
                                updateParent={this.props.updateParent} 
                                openCardEvent={this.props.openCardEvent}
                            />
                        </Layout.Content>
                    </Layout>
            </div>
            );
        }
    }
}
