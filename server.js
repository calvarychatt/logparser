const express = require('express')
const app = express()
const fs = require('fs')
const path = require('path')

const exec = require('child_process').exec;

const port = 3000





app.get('/', (request, response) => {
  response.send('Hello from Express!')
})

app.get('/log', (req, res) => {
  exec("awk '{print $1, $7}' server.log | sort | uniq | sed 's=/==g' | sed 's=.pac==g'", (e, stdout, stderr)=> {
      if (e instanceof Error) {
          console.error(e);
          throw e;
      }
      console.log('stdout ', stdout);
      console.log('stderr ', stderr);
      res.send(stdout)
  });
  // res.sendFile(__dirname + '/server.log')
  res.end
})


app.listen(port, (err) => {
  if (err) {
    return console.log('something bad happened', err)
  }

  console.log(`server is listening on ${port}`)
})

