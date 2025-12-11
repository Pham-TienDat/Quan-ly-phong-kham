import React from 'react';

const Sidebar = () => {
  const menuItems = [
    { name: 'Tổng Quan', iconClass: 'bi bi-grid-fill', path: '/' },
    { name: 'Quản Lý Bệnh Nhân', iconClass: 'bi bi-person-lines-fill', path: '/patients' },
    { name: 'Lịch Hẹn', iconClass: 'bi bi-calendar-check-fill', path: '/appointments' },
    { name: 'Hồ Sơ Y Tế', iconClass: 'bi bi-file-earmark-medical-fill', path: '/records' },
    { name: 'Quản Lý Thuốc', iconClass: 'bi bi-capsule', path: '/medicine' },
    { name: 'Cài Đặt', iconClass: 'bi bi-gear-fill', path: '/settings' },
  ];

  // Lưu ý: Thư viện Bootstrap Icons (bi bi-...) cần được cài đặt nếu muốn dùng icon
  // Ví dụ: npm install bootstrap-icons

  return (
    <div className="d-flex flex-column flex-shrink-0 p-3 text-white bg-dark" style={{ width: '250px' }}>
      <a href="/" className="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
        <span className="fs-4">Clinic Manager</span>
      </a>
      <hr className="border-secondary" />
      <ul className="nav nav-pills flex-column mb-auto">
        {menuItems.map((item, index) => (
          <li className="nav-item" key={index}>
            <a 
              href={item.path} 
              className={`nav-link text-white ${item.path === '/' ? 'active' : ''}`} 
              aria-current={item.path === '/' ? 'page' : undefined}
            >
              <i className={`${item.iconClass} me-2`}></i>
              {item.name}
            </a>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default Sidebar;