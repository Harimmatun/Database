import asyncio
from prisma import Prisma

async def main() -> None:
    db = Prisma()
    await db.connect()
    print("--- 1. Підключення успішне ---")

    category = await db.categories.create(
        data={'name': 'Electronics'}
    )
    print(f"Створено категорію: {category.name}")

    brand = await db.brands.create(
        data={'name': 'Samsung'}
    )
    print(f"Створено бренд: {brand.name}")

    supplier = await db.supplier.create(
        data={'name': 'Tech World LLC'}
    )
    print(f"Створено постачальника: {supplier.name}")

    product = await db.products.create(
        data={
            'name': 'Samsung Galaxy S24',
            'price': 35000.00,
            'stock_quantity': 10,
            'category_id': category.category_id, 
            'brand_id': brand.brand_id,       
            
            'is_active': True,
            'supplier_id': supplier.id           
        }
    )
    print(f"Створено товар: {product.name} (Активний: {product.is_active})")

    print("\n--- Звіт: Товари та їх постачальники ---")
    
    products = await db.products.find_many(
        include={
            'Supplier': True, 
            'categories': True 
        }
    )

    for p in products:
        sup_name = p.Supplier.name if p.Supplier else "Без постачальника"
        cat_name = p.categories.name if p.categories else "Без категорії"
        print(f"Товар: {p.name} | Категорія: {cat_name} | Постачальник: {sup_name}")

    await db.disconnect()

if __name__ == '__main__':
    asyncio.run(main())