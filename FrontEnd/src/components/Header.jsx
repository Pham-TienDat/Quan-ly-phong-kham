import React from 'react';

const Header = () => {
  return (
    <nav className="navbar navbar-light bg-white shadow-sm">
      <div className="container-fluid">
        <span className="navbar-brand mb-0 h1">Dashboard Phòng Khám</span>
        
        <div className="d-flex align-items-center">
          {/* Nút Thông báo */}
          <button className="btn btn-outline-secondary me-3" type="button">
            <i className="bi bi-bell"></i> Thông báo
          </button>
          
          {/* Thông tin người dùng */}
          <div className="dropdown">
            <a 
              className="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" 
              href="#" 
              id="userDropdown" 
              data-bs-toggle="dropdown" 
              aria-expanded="false"
            >
              <img 
                src="https://via.placeholder.com/30" 
                alt="Avatar" 
                width="30" 
                height="30" 
                className="rounded-circle me-2"
              />
              <strong>Bác sĩ An</strong>
            </a>
            <ul className="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
              <li><a className="dropdown-item" href="#">Profile</a></li>
              <li><a className="dropdown-item" href="#">Settings</a></li>
              <li><hr className="dropdown-divider" /></li>
              <li><a className="dropdown-item" href="#">Sign out</a></li>
            </ul>
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Header;