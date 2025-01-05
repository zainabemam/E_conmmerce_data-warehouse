# E-commerce Data Warehouse and ETL Pipeline

## **Overview**
This project implements a Data Warehouse (DW) and an ETL (Extract, Transform, Load) pipeline for an e-commerce dataset. The project analyzes customer behavior and feedback, payment, and other business insights. The goal is to design an optimized data model, load data efficiently, and generate actionable insights by answering key business questions.

## **Key Features**
- Designed a star schema for the data warehouse with fact and dimension tables.
- Implemented an ETL pipeline to clean, transform, and load data into the database.
- Analyzed business questions and provided SQL queries to extract insights.
- Automated data export to CSV for further reporting.

## **Technologies Used**
- **Database**: SQLite  
- **Programming**: Python (with Pandas and sqlite3 libraries)  
- **IDE**: VS Code   
- **Dataset**: E-commerce transactional data (e.g., users, orders,order item ,payments, seller,product and feedback).  

## **Data Model**
The data warehouse uses a star schema with the following tables:

### **Fact Tables**
1. **Order Fact**  
   - Contains transactional data about orders, delivery, and payment.

2. **Order Item Fact**  
   - Contains item-level details like product, price, and shipping cost.

### **Dimension Tables**
1. **User Dimension**  
   - Provides user-level demographic information.

2. **Product Dimension**  
   - Includes product attributes such as weight, dimensions, and category.

3. **Seller Dimension**  
   - Captures seller details like location and ID.

4. **Payment Dimension**  
   - Tracks payment methods, installments, and payment values.

5. **Feedback Dimension**  
   - Records customer feedback and satisfaction data.

## **Business Questions Answered**
The project answers the following key business questions using SQL queries:
1. **Peak Season**: Identify months with the highest order volumes.  
2. **Order Timing**: Determine the time of day customers are most active.  
3. **Preferred Payment Method**: Analyze the most popular payment methods.  
4. **Installment Trends**: Calculate average payment installments.  
5. **Average Order Spending**: Assess average user spending.  
6. **State-wise Purchases**: Measure purchase frequency across states.  
7. **Logistic Performance**: Identify routes with heavy traffic and late deliveries.  
8. **Customer Satisfaction**: Analyze the effect of late deliveries on feedback scores.  
9. **Delivery Delays**: Calculate delays by state and the difference between estimated and actual delivery times.

## **Project Workflow**
1. **Data Preparation**:  
   - Loaded data from multiple CSV files.  
   - Performed cleaning (e.g., handling missing values, removing duplicates).  
   - Applied transformations to match the schema.

2. **ETL Pipeline**:  
   - Extracted data from source files.  
   - Transformed and enriched data for consistency and schema compatibility.  
   - Loaded data into an SQLite database.

3. **Analysis**:  
   - Wrote SQL queries to address business questions.  
   - Exported query results to `.csv` files for reporting.



