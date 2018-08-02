import React from 'react'

export class Counter extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            count: props.count || 0
        }
    }
    
    handleClick() {
        this.setState({
            count: this.state.count + 1
        })
    }

    render() {
        return (
            <div>
                <div>COUNT: {this.state.count}</div>
                <div><input type="button" value="COUNT UP" onClick={() => this.handleClick()} /></div>
            </div>
        )
    }
}