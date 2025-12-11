import React from 'react';
import Header from '../components/Header.jsx';
import Sidebar from '../components/Sidebar.jsx';
import DashboardCard from '../components/DashboardCard.jsx';

const HomePage = () => {
  // Dữ liệu giả định cho Dashboard
  const cardData = [
    { title: 'Bệnh nhân hôm nay', value: 45, iconClass: 'bi bi-people-fill', cardClass: 'bg-primary' },
    { title: 'Lịch hẹn chờ', value: 8, iconClass: 'bi bi-clock-fill', cardClass: 'bg-warning' },
    { title: 'Doanh thu hôm nay', value: '15,000,000 đ', iconClass: 'bi bi-cash-stack', cardClass: 'bg-success' },
    { title: 'Đơn thuốc mới', value: 12, iconClass: 'bi bi-journal-text', cardClass: 'bg-danger' },
  ];

  return (
    <div className="d-flex">
      <Sidebar />
      <div className="flex-grow-1 d-flex flex-column">
        <Header />
        <main className="p-4 flex-grow-1" style={{ backgroundColor: '#f8f9fa' }}>
          <h2 className="mb-4 text-dark">Tổng Quan (Dashboard)</h2>

          {/* 1. Khu vực Thẻ thống kê nhanh */}
          <div className="row">
            {cardData.map((data, index) => (
              <div className="col-md-6 col-lg-3" key={index}>
                <DashboardCard {...data} />
              </div>
            ))}
          </div>

          {/* 2. Khu vực Biểu đồ/Danh sách chính */}
          <div className="row mt-4">
            
            {/* Cột 1 & 2: Biểu đồ (Hoạt động khám bệnh) */}
            <div className="col-lg-8">
              <div className="card shadow-sm h-100">
                <div className="card-body">
                  <h3 className="card-title">Hoạt động khám bệnh 7 ngày qua</h3>
                  <hr />
                  {/* Đây là nơi đặt component biểu đồ */}
                  <div className="d-flex align-items-center justify-content-center border border-dashed rounded" style={{ height: '300px' }}>
                    [Nơi đặt Biểu đồ sử dụng thư viện như Chart.js hoặc Recharts]
                  </div>
                </div>
              </div>
            </div>

            {/* Cột 3: Danh sách Lịch hẹn gần nhất */}
            <div className="col-lg-4">
              <div className="card shadow-sm h-100">
                <div className="card-body">
                  <h3 className="card-title">Lịch hẹn sắp tới</h3>
                  <hr />
                  <ul className="list-group list-group-flush">
                    <li className="list-group-item">9:00 AM - Nguyễn Văn A</li>
                    <li className="list-group-item">10:30 AM - Trần Thị B</li>
                    <li className="list-group-item">11:00 AM - Lê Văn C</li>
                    <li className="list-group-item list-group-item-action text-primary">Xem tất cả lịch hẹn...</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  );
};

export default HomePage;