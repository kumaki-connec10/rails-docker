import React from 'react'
import ReactDOM from 'react-dom'
import * as counter from './counter/index'

document.addEventListener("DOMContentLoaded", e => {
    ReactDOM.render(<counter.Counter />, document.body.appendChild(document.createElement('div')))
})