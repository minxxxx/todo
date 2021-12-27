import React, { Component } from 'react';
import './styles.css';
import PlacesAutocomplete, { geocodeByAddress, getLatLng} from 'react-places-autocomplete';
import Map from '../map'

export default class LocationSearchInput extends Component {
  constructor(props) {
    super(props);
    this.state = {
      location: {
        address: '',
        coord  : ''
      },
      addressObj: '',
      key: 0
    };
  }
  handleChange = address => {
    this.setState({ address });
  }
  handleSelect = address => {
    geocodeByAddress(address)
      .then(results =>  {
        let location = { address : results[0]}
        this.setState({'address': results[0].formatted_address,'addressObj': results[0]}) 
        getLatLng(results[0]).then(results => {
          location.coord = results;
          this.setState({location: location, 'key': 1})
          this.props.updateLocation(this.state)
        })
      })
      .then(latLng => console.log('Success', latLng))
      .catch(error => console.error('Error', error));
  }
	render() {
			return (
        <div >
          <PlacesAutocomplete
            value={this.state.address ? this.state.address : ''}
            onChange={this.handleChange}
            onSelect={this.handleSelect.bind(this)}
          >
          {({ getInputProps, suggestions, getSuggestionItemProps, loading }) => (
            <div>
              <input
                {...getInputProps({
                  placeholder: 'Search Places ...',
                  className: 'location-search-input',
                })}
              />
              <div className="autocomplete-dropdown-container searchResultStyle">
                {loading && <div>Loading...</div>}
                {suggestions.map(suggestion => {
                  const className = suggestion.active
                    ? 'suggestion-item--active'
                    : 'suggestion-item';
                  // inline style for demonstration purpose
                  const style = suggestion.active
                    ? { backgroundColor: '#fafafa', cursor: 'pointer', borderTop: '1px solid #9e9e9e', borderBottom: '1px solid #9e9e9e' }
                    : { backgroundColor: '#ffffff', cursor: 'pointer'};
                  return (
                    <div
                      {...getSuggestionItemProps(suggestion, {
                        className,
                        style,
                      })}
                    >
                      <span>{suggestion.description}</span>
                    </div>
                  );
                })}
              </div>
            </div>
          )}
        </PlacesAutocomplete>
        {
          this.props.displayMap  ? 
            <Map 
              state={this.props.state} 
              events={this.props.state.data.event ? [this.props.state.data.event] : []} 
              center={this.state.location.coord}
            /> 
            : 
            null 
        }
        </div>
			);
		}
}
