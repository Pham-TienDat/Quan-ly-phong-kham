import React from 'react';
import HomePage from './pages/HomePage.jsx';
import 'bootstrap/dist/css/bootstrap.min.css';
// Lưu ý: Nếu muốn dùng Dropdown trong Header, bạn cần import JS của Bootstrap
// import 'bootstrap/dist/js/bootstrap.bundle.min.js'; 

function App() {
  return (
    <div className="App">
      <HomePage />
    </div>
  );
}

export default App;