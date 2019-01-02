# // Tests

Theoretically, since request and offer timestamps can be retrieved and compared by both
web server and blockchain server. The following call sequences to ReviewsController.sol should not be made from the blockchain server.


# // Test batch R000
    requestServices( 0, 0, [1,2,3], { from: 0xAA })
Followed by each of the following test cases...

## R000/R000-R101

#### // Test case R000/R000
    requestServices( 0, 0, [1,2,3], { from: 0xAA })
#### // Test case R000/R001
    requestServices( 0, 0, [1,2],   { from: 0xBB })
#### // Test case R000/R010
    requestServices( 0, 1, [2,3],   { from: 0xAA })
#### // Test case R000/R011
    requestServices( 0, 1, [2,3,4], { from: 0xBB })
#### // Test case R000/R100
    requestServices( 1, 0, [2,4,6], { from: 0xAA })
#### // Test case R000/R101
    requestServices( 1, 0, [2,3,7], { from: 0xBB })

Tx status should be:
> `Failed: Revert();`

Our HTTP response status code should be:
> 403 Forbidden

---

## R000/R110-R111

    requestServices( 0, 0, [1,2,3], { from: 0xAA })
Followed by each of the following test cases...

#### // Test case R000/R110
    requestServices( 1, 1, [2,3,5], { from: 0xAA })
#### // Test case R000/R111
    requestServices( 1, 1, [6,7],   { from: 0xBB })
    
Tx status should be:
> `Success!`

Our HTTP response status code should be:
> 200 OK

---

## R000/O000-O010,O100-O111

#### // Test case R000/O000
    offerServices( 0, 0, 688,   { from: 0xAA })
#### // Test case R000/O001
    offerServices( 0, 0, 3244,  { from: 0xBB })
#### // Test case R000/O010
    offerServices( 0, 1, 57335, { from: 0xAA })
#### // Test case R000/O100
    offerServices( 1, 0, 123,   { from: 0xAA })
#### // Test case R000/O101
    offerServices( 1, 0, 77,    { from: 0xBB })
#### // Test case R000/O110
    offerServices( 1, 1, 323,   { from: 0xAA })
#### // Test case R000/O111
    offerServices( 1, 1, 893,   { from: 0xBB })

Tx status should be:
> `Failed: Revert();`

Our HTTP response status code should be:
> 403 Forbidden

---

## R000/O011

#### // Test case R000/O011
    offerServices( 0, 1, 377,   { from: 0xBB })

Tx status should be:
> `Success!`

Our HTTP response status code should be:
> 200 OK

---

## R000/O011/O011-O012

#### // Test caseR000/O011/O011
    offerServices( 0, 1, 342,   { from: 0xBB }) 
#### // Test case R000/O011/O012
    offerServices( 0, 2, 342,   { from: 0xBB })

Tx status should be:
> `Failed: Revert();`

Our HTTP response status code should be:
> 403 Forbidden

---

## R000/O011/O022

#### // Test case R000/O011/O022
    offerServices( 0, 2, 342,   { from: 0xCC }) 

Tx status should be:
> `Success!`

Our HTTP response status code should be:
> 200 OK

---