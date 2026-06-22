# Screens:
## Dashboard Screen:
- Total Tickets
- Open Tickets
- In Progress Tickets
- Closed Tickets

## Ticket List Screen:

Display all tickets in a list.
Each ticket should show:
• Ticket ID
• Subject
• Priority
• Status
• Created Date

Allow users to:
• Search tickets by Subject
• Filter by Status
• Sort by Created Date


## Create Ticket Screen:
• Subject (Required)
• Description (Required)
• Priority
    o Low
    o Medium
    o High

• Category
    o Technical
    o Billing
    o General

Automatically generate:
• Ticket Number
• Creation Date
• Initial Status = Open


## Ticket Details Screen:
Display all ticket information.
Allow users to:
• Change Status
    o Open
    o In Progress
    o Closed

• Edit Subject
• Edit Description
• Update Priority

Delete Ticket
Allow deleting a ticket with a confirmation dialog

# Models:


## Ticket:
    - id
    - subject
    - priority
    - status
    - created_date

