# 🔁 HTML to Pug Guide
## 1. Basic Structure
### 🔠 HTML:
```
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>My Site</title>
  </head>
  <body>
    <h1>Welcome</h1>
    <p>This is a paragraph.</p>
  </body>
</html>
```
### 🐶 Pug:
```
doctype html
html(lang="en")
  head
    title My Site
  body
    h1 Welcome
    p This is a paragraph.
```
## 2. Classes and IDs
### 🔠 HTML:
```
<div id="main" class="container">
  <p class="text">Hello World</p>
</div>
```
### 🐶 Pug:
```
div#main.container
  p.text Hello World
```
## 3. Attributes
### 🔠 HTML:
```
<input type="text" placeholder="Enter your name" />
```
### 🐶 Pug:
```
input(type="text", placeholder="Enter your name")
```
## 4. Loops and Conditionals
### 🔠 HTML:
```
<ul>
  <% for(var i=0; i<items.length; i++) { %>
    <li><%= items[i] %></li>
  <% } %>
</ul>
```
### 🐶 Pug:
```
ul
  each item in items
    li= item
```
# 📚 Additional Resources
[Official Pug Documentation](https://pugjs.org/)