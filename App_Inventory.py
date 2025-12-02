import tkinter as tk
from tkinter import ttk, messagebox
import pyodbc

DB_CONFIG = (
    "DRIVER={SQL Server};"
    r"SERVER=.\SQLEXPRESS;"
    "DATABASE=QuanLyKho_Final;"
    "Trusted_Connection=yes;"
)

def get_connection():
    return pyodbc.connect(DB_CONFIG)

def load_data():
    for row in tree.get_children():
        tree.delete(row)

    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT MaHang, TenHang, NoiSanXuat FROM HangHoa")
        
        rows = cursor.fetchall()
        for row in rows:
            tree.insert("", "end", values=(row.MaHang, row.TenHang, row.NoiSanXuat))
            
        conn.close()
    except Exception as e:
        messagebox.showerror("Error", f"{e}")

def them_hang():
    ma = entry_ma.get()
    ten = entry_ten.get()
    noisx = entry_noisx.get()

    if not ma or not ten:
        messagebox.showwarning("Warning", "Thieu thong tin")
        return

    try:
        conn = get_connection()
        cursor = conn.cursor()
        
        sql = "INSERT INTO HangHoa (MaHang, TenHang, NoiSanXuat) VALUES (?, ?, ?)"
        cursor.execute(sql, (ma, ten, noisx))
        conn.commit()
        conn.close()

        messagebox.showinfo("Success", "OK")
        
        entry_ma.delete(0, tk.END)
        entry_ten.delete(0, tk.END)
        entry_noisx.delete(0, tk.END)
        
        load_data()

    except Exception as e:
        messagebox.showerror("Error", f"{e}")

def xoa_hang():
    selected_item = tree.selection()
    
    if not selected_item:
        return

    row_values = tree.item(selected_item)['values']
    ma_hang = row_values[0]

    confirm = messagebox.askyesno("Confirm", f"Xoa ma: {ma_hang}?")
    if confirm:
        try:
            conn = get_connection()
            cursor = conn.cursor()
            
            sql = "DELETE FROM HangHoa WHERE MaHang = ?"
            cursor.execute(sql, (ma_hang,))
            conn.commit()
            conn.close()
            
            messagebox.showinfo("Success", "Deleted")
            load_data()

        except Exception as e:
            messagebox.showerror("Error", f"{e}")

root = tk.Tk()
root.title("App Quan Ly Kho")
root.geometry("700x550")

frame_input = tk.Frame(root, pady=20)
frame_input.pack()

tk.Label(frame_input, text="Ma Hang:", font=("Arial", 10)).grid(row=0, column=0, padx=5)
entry_ma = tk.Entry(frame_input, font=("Arial", 10))
entry_ma.grid(row=0, column=1, padx=5)

tk.Label(frame_input, text="Ten Hang:", font=("Arial", 10)).grid(row=0, column=2, padx=5)
entry_ten = tk.Entry(frame_input, font=("Arial", 10), width=30)
entry_ten.grid(row=0, column=3, padx=5)

tk.Label(frame_input, text="Noi SX:", font=("Arial", 10)).grid(row=0, column=4, padx=5)
entry_noisx = tk.Entry(frame_input, font=("Arial", 10))
entry_noisx.grid(row=0, column=5, padx=5)

frame_btn = tk.Frame(root)
frame_btn.pack(pady=10)

btn_them = tk.Button(frame_btn, text="THEM MOI", bg="#008CBA", fg="white", font=("Arial", 10, "bold"), width=15, command=them_hang)
btn_them.grid(row=0, column=0, padx=10)

btn_xoa = tk.Button(frame_btn, text="XOA DONG", bg="#f44336", fg="white", font=("Arial", 10, "bold"), width=15, command=xoa_hang)
btn_xoa.grid(row=0, column=1, padx=10)

columns = ("Ma", "Ten", "NoiSX")
tree = ttk.Treeview(root, columns=columns, show="headings", height=15)

tree.heading("Ma", text="Ma Hang")
tree.column("Ma", width=100, anchor="center")

tree.heading("Ten", text="Ten Hang Hoa")
tree.column("Ten", width=300)

tree.heading("NoiSX", text="Noi San Xuat")
tree.column("NoiSX", width=150, anchor="center")

tree.pack(fill="both", expand=True, padx=20, pady=20)

if __name__ == "__main__":
    load_data()
    root.mainloop()