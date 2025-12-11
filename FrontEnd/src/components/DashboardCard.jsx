import React from 'react';

const DashboardCard = ({ title, value, iconClass, cardClass }) => {
  return (
    <div className={`card text-white ${cardClass} mb-3`}>
      <div className="card-body">
        <div className="row">
          <div className="col-4 d-flex align-items-center justify-content-center">
            <i className={`${iconClass} display-4`}></i>
          </div>
          <div className="col-8 text-end">
            <p className="card-text mb-0 opacity-75">{title}</p>
            <h2 className="card-title">{value}</h2>
          </div>
        </div>
      </div>
      <div className="card-footer bg-transparent border-white border-opacity-25">
        <small>Xem chi tiết <i className="bi bi-arrow-right"></i></small>
      </div>
    </div>
  );
};

export default DashboardCard;