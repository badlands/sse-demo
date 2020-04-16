Server-Sent Events (SSEs), Node.js (Express.js), and Redis
==========================================================

This is an example application demonstrating one way to approach
delivering Server-Sent Events with Node.js (leveraging Express.js).



Requirements
------------

1. Node.js
1. Express.js

Using it...
-----------

1. Clone the repo locally
1. cd into the cloned directory
1. run `mkdir tmp`
1. run `npm start`
1. Visit http://localhost:3000/sse in one browser window
1. run `cd tmp`
1. run `touch 1.tmp`
1. Look at the page again... and you should see a message including the name of the file you just created
