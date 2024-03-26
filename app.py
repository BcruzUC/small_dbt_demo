from flask import Flask, render_template, jsonify
import psycopg2
import plotly.graph_objs as go

app = Flask(__name__)

# PostgreSQL connection settings
DB_NAME = 'demo_dbt'
DB_USER = 'benjacruz'
DB_PASSWORD = 'bcruz123'
DB_HOST = 'localhost'  # Change if PostgreSQL is hosted elsewhere

# Function to fetch data from PostgreSQL
def fetch_data(query):
    conn = psycopg2.connect(dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD, host=DB_HOST)
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    conn.close()
    return data

# Sample bar chart data query
def get_bar_chart_data():
    query = """
    SELECT order_date, average_payment_order
    FROM public_marts.average_transaction_order
    """
    data = fetch_data(query)
    categories = [row[0] for row in data]
    counts = [row[1] for row in data]
    return categories, counts

# Route for rendering the dashboard
@app.route('/')
def dashboard():
    # Get data for bar chart
    categories, counts = get_bar_chart_data()

    # Create bar chart
    bar_chart = go.Bar(x=categories, y=counts)

    # Plot layout
    layout = dict(title='Orders by Category', xaxis=dict(title='Category'), yaxis=dict(title='Count'))

    # Render bar chart
    bar_chart_fig = go.Figure(data=[bar_chart], layout=layout)
    bar_chart_json = bar_chart_fig.to_json()

    return render_template('dashboard.html', bar_chart_json=bar_chart_json)

if __name__ == '__main__':
    app.run(debug=True)
