async function loadAppointments() {
    const tableBody = document.getElementById('appointmentList');
    
    // Hiển thị trạng thái đang tải (tùy chọn nhưng nên có)
    tableBody.innerHTML = '<tr><td colspan="5" style="text-align:center;">Đang tải dữ liệu...</td></tr>';

    try {
        // 1. Gọi đến file PHP backend
        const response = await fetch('http://localhost/clinic/api/get_appointments.php');
        
        // 2. Kiểm tra nếu phản hồi từ server ok
        if (!response.ok) throw new Error('Không thể kết nối với server');

        // 3. Chuyển đổi dữ liệu nhận được thành JSON
        const appointments = await response.json();

        // 4. Kiểm tra nếu có dữ liệu
        if (appointments.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="5" style="text-align:center;">Không có lịch hẹn nào hôm nay.</td></tr>';
            return;
        }

        // 5. Đổ dữ liệu vào bảng (Lưu ý: tên cột phải khớp với tên cột trong database)
        tableBody.innerHTML = appointments.map(appt => `
            <tr>
                <td><strong>${appt.ten_benh_nhan}</strong></td>
                <td>${appt.start_time}</td>
                <td>${appt.ten_bac_si}</td>
                <td><span class="status-pill">${appt.status}</span></td>
                <td>
                    <button onclick="viewDetail('${appt.patient_name}')" 
                            style="cursor:pointer; border:none; background:none; color:blue; text-decoration:underline;">
                        Chi tiết
                    </button>
                </td>
            </tr>
        `).join('');

    } catch (error) {
        console.error('Lỗi:', error);
        tableBody.innerHTML = `<tr><td colspan="5" style="text-align:center; color:red;">Lỗi tải dữ liệu: ${error.message}</td></tr>`;
    }
}

        //  Hàm load Sidebar dùng chung
        async function loadSidebar() {
            const response = await fetch('sidebar.html');
            const data = await response.text();
            document.getElementById('sidebar-placeholder').innerHTML = data;

            const path = window.location.pathname;
            let page = path.split("/").pop().replace(".html", "");
            const activeItem = document.getElementById('nav-' + page);
            if (activeItem) {
            // Xóa active cũ nếu có (để an toàn)
            document.querySelectorAll('.nav-item').forEach(el => el.classList.remove('active'));
            // Thêm active mới
            activeItem.classList.add('active');
        }
        }
        // HÀM ĐIỀU HƯỚNG TRANG 
        function navigateTo(page) {
            window.location.href = page + ".html";
        }

        function createNewAppointment() {
            const name = prompt("Nhập tên bệnh nhân mới:");
            if (name) {
                alert("Đã tạo lịch hẹn cho: " + name);
            }
        }


       