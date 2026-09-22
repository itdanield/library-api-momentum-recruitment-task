# Library API

Recruitment task for Ruby on Rails Developer position at Momentum.

## Overview

Library management API built with Ruby on Rails.

The application allows library employees to:

- Add new books
- Delete books
- List all books
- View book details together with borrowing history
- Register book borrowings
- Register book returns
- Manage readers
- Generate reminders for books that are close to their return date

Authentication and authorization were intentionally omitted according to the task requirements.

---

## Tech Stack

- Ruby 3.3
- Ruby on Rails 8
- PostgreSQL
- RSpec
- FactoryBot
- Docker
- Docker Compose

---

## Running the Application

Build and start the application:

```bash
docker compose up --build
```

The API will be available at:

```text
http://localhost:3000
```

The application automatically creates and migrates the database during startup.

---

## Running Tests

Run the test suite inside the Docker container:

```bash
docker compose exec web bundle exec rspec
```

Alternatively:

```bash
docker compose run --rm web bundle exec rspec
```

---

## API Endpoints

### Books

#### List all books

```http
GET /api/books
```

#### Show a single book

```http
GET /api/books/:id
```

Returns book details together with borrowing history.

#### Create a book

```http
POST /api/books
```

Example payload:

```json
{
  "title": "Clean Code",
  "author": "Robert C. Martin",
  "serial_number": "123456"
}
```

#### Delete a book

```http
DELETE /api/books/:id
```

#### Borrow a book

```http
POST /api/books/:id/borrow
```

Example payload:

```json
{
  "reader_id": 1
}
```

#### Return a book

```http
POST /api/books/:id/return_book
```

---

### Readers

#### List all readers

```http
GET /api/readers
```

#### Show a single reader

```http
GET /api/readers/:id
```

#### Create a reader

```http
POST /api/readers
```

Example payload:

```json
{
  "full_name": "John Doe",
  "email": "john@example.com",
  "card_number": "654321"
}
```

---

## Domain Model

### Book

Represents a book owned by the library.

Attributes:

- serial_number
- title
- author

### Reader

Represents a library reader.

Attributes:

- card_number
- full_name
- email

### Borrowing

Represents a borrowing event.

Attributes:

- borrowed_at
- due_date
- returned_at

A book is borrowed for 30 days.

Borrowing history is preserved even after a book has been returned.

---

## Reminder Job

The application contains a `ReminderJob` responsible for finding active borrowings that are due in 3 days.

According to the task requirements, real emails are not sent. Instead, the reminder payload is logged through Rails logger.

Example payload:

```json
{
  "email": "reader@example.com",
  "subject": "Book return reminder",
  "book": "Clean Code",
  "due_date": "2026-10-01"
}
```

---

## Design Decisions

### Separate Borrowing Model

Borrowing history is stored in a dedicated `Borrowing` model instead of directly on the `Book` model.

This makes it possible to:

- preserve complete borrowing history
- store borrow and return dates
- associate borrowings with readers
- support future extensions

### Service Objects

Business logic related to borrowing and returning books was extracted into service objects:

- `BorrowBookService`
- `ReturnBookService`

This keeps controllers thin and makes the business rules easier to test.

### Request Specs

The API is covered with request specs that verify:

- successful requests
- validation failures
- resource deletion
- borrow and return workflows
- error handling

### Custom Errors

Custom exceptions are used for domain-specific business rules:

- `BookAlreadyBorrowedError`
- `BookNotBorrowedError`

These are handled centrally in `ApplicationController`.

---

## Future Improvements

Possible future improvements:

- authentication and authorization
- pagination
- API versioning
- OpenAPI / Swagger documentation
- background job scheduling for reminders
- email delivery integration
- rate limiting

---

## Test Coverage

The project includes tests for:

- models
- validations
- service objects
- API endpoints
- reminder job

Run all tests:

```bash
docker compose exec web bundle exec rspec
```
