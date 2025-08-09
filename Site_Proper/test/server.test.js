const test = require('ava');
const request = require('supertest');
const sinon = require('sinon');

// Mock the database module before importing server
const dbMock = {
  query: sinon.stub(),
  transact: sinon.stub(),
  connect: sinon.stub().returns({
    query: sinon.stub(),
    release: sinon.stub()
  })
};

// Mock the database module
require.cache[require.resolve('../database')] = {
  exports: dbMock
};

const { app } = require('../server.js');

let server;

test.before(() => {
  // Start server on random port for testing
  server = app.listen(0);
});

test.after.always(async () => {
  // Properly close server and clear stubs
  await new Promise((resolve) => {
    server.close(resolve);
  });
  sinon.restore();
});

test.beforeEach(() => {
  // Reset all stubs before each test
  sinon.resetHistory();
  dbMock.query.reset();
  dbMock.transact.reset();
});

// Basic Route Tests
test('app is defined', t => {
  t.truthy(app, 'Express app should be defined');
});

test('GET / (home) returns 200', async t => {
  const res = await request(app).get('/');
  t.is(res.status, 200);
});

test('GET /login returns 200', async t => {
  const res = await request(app).get('/login');
  t.is(res.status, 200);
});

test('GET /signup.html returns 200', async t => {
  const res = await request(app).get('/signup.html');
  t.is(res.status, 200);
});

// Homepage Tests (with database mocking)
test('GET /homepage.html - guest user', async t => {
  const res = await request(app).get('/homepage.html');
  t.is(res.status, 200);
});

test('GET /homepage.html - logged in user', async t => {
  // Mock successful user query
  dbMock.query.resolves({
    rows: [{ role_id: 2, username: 'testuser' }]
  });

  const agent = request.agent(app);
  
  // First login to establish session
  dbMock.query.onFirstCall().resolves({
    rows: [{ id: 1, email: 'test@example.com' }]
  });
  
  await agent
    .post('/login')
    .send({ email: 'test@example.com', password: 'password123' });

  // Then access homepage
  dbMock.query.onSecondCall().resolves({
    rows: [{ role_id: 2, username: 'testuser' }]
  });

  const res = await agent.get('/homepage.html');
  t.is(res.status, 200);
});

// Login Tests
test('POST /login - successful login', async t => {
  dbMock.query.resolves({
    rows: [{ id: 1, email: 'test@example.com' }]
  });

  const res = await request(app)
    .post('/login')
    .send({ email: 'test@example.com', password: 'validPassword123!' });
  
  t.is(res.status, 302);
  t.true(res.headers.location.includes('/homepage.html'));
});

test('POST /login - failed login', async t => {
  dbMock.query.resolves({ rows: [] });

  const res = await request(app)
    .post('/login')
    .send({ email: 'test@example.com', password: 'wrongpassword' });
  
  t.is(res.status, 302);
  t.true(res.headers.location.includes('/login.html?error=1'));
});

test('POST /login - database error', async t => {
  dbMock.query.rejects(new Error('Database error'));

  const res = await request(app)
    .post('/login')
    .send({ email: 'test@example.com', password: 'password' });
  
  t.is(res.status, 500);
});

// Signup Tests
test('POST /signup - successful registration', async t => {
  dbMock.query.resolves({ rows: [] }); // No existing user
  dbMock.transact.resolves();

  const res = await request(app)
    .post('/signup')
    .send({
      email: 'newuser@example.com',
      password: 'ValidPass123!',
      role: 'User'
    });

  t.is(res.status, 302);
  t.true(res.headers.location.includes('/login.html?success=1'));
});

// Logout Tests
test('GET /logout - successful logout', async t => {
  const agent = request.agent(app);
  
  // Login first
  dbMock.query.resolves({
    rows: [{ id: 1, email: 'test@example.com' }]
  });
  
  await agent
    .post('/login')
    .send({ email: 'test@example.com', password: 'password' });

  const res = await agent.get('/logout');
  t.is(res.status, 302);
  t.true(res.headers.location.includes('/login.html'));
});

test('GET /logout - no session', async t => {
  const res = await request(app).get('/logout');
  t.is(res.status, 302);
  t.true(res.headers.location.includes('/login.html?error=2'));
});

// Event Matcher Tests
test('GET /eventMatcher - default order', async t => {
  dbMock.query.resolves({
    rows: [
      {
        id: 1,
        name: 'Test Event',
        moderator: 'testmod',
        location: 'Test Location',
        skills: ['skill1', 'skill2'],
        description: 'Test Description',
        priority: 'high',
        date: '2024-01-01',
        published: '2024-01-01 12:00:00'
      }
    ]
  });

  const res = await request(app).get('/eventMatcher');
  t.is(res.status, 200);
});

test('GET /eventMatcher - order by skill (logged in)', async t => {
  const agent = request.agent(app);
  
  // Login first
  dbMock.query.onFirstCall().resolves({
    rows: [{ id: 1, email: 'test@example.com' }]
  });
  
  await agent
    .post('/login')
    .send({ email: 'test@example.com', password: 'password' });

  // Mock user query for skills
  dbMock.query.onSecondCall().resolves({
    rows: [{ id: 1, skill: ['javascript', 'python'] }]
  });

  // Mock events query
  dbMock.query.onThirdCall().resolves({
    rows: [
      {
        id: 1,
        name: 'Test Event',
        moderator: 'testmod',
        location: 'Test Location',
        skills: ['javascript'],
        description: 'Test Description',
        priority: 'high',
        date: '2024-01-01',
        published: '2024-01-01 12:00:00'
      }
    ]
  });

  const res = await agent.get('/eventMatcher?orderby=skill');
  t.is(res.status, 200);
});

test('GET /eventMatcher - database error', async t => {
  dbMock.query.rejects(new Error('Database error'));

  const res = await request(app).get('/eventMatcher');
  t.is(res.status, 500);
});

test('POST /enrollTask - not logged in', async t => {
  const res = await request(app)
    .post('/enrollTask')
    .send({ taskId: 1 });

  t.is(res.status, 302);
  t.true(res.headers.location.includes('/login.html?error=2'));
});