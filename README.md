# Vending Machine Inventory Update

Shell script to update an inventory table, from an update file.

The script accepts the following parameters.

 - The original inventory filename as $1
 - The update filename as $2
 - The output should be send to stdout
 
**Inventory File Sample:**

"MachineID","ItemA","ItemB","Last_Update"<br>
"MA001",100,200,2020-01-01<br>
"MA002",300,400,2020-01-01<br>
"MA003",200,250,2020-01-01
 
**Update file Sample:**
> The information in the update file is used to modify the inventory data and send the revised version of the table to stdout.

"MachineID","Item","Operation"<br>
"MA004","ItemA",500<br>
"MA001","ItemB",+200<br>
"MA003","ItemA",-200

The update file contains 3 columns:

 - The MachineID, contains the machine to update
 - The Item, contains the item to update.
 - The Operation contains the operation to perform
 
  >If it's just a number, assign that value as the amount for the item in the machine.
  If there is a "+" in front of the number, add that amount to the amount already in the machine for that item
  If there is a "-" in front of the number, subtract that amount to the amount already in the machine.
