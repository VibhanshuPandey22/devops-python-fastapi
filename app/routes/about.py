from fastapi import APIRouter

router = APIRouter()

@router.get("/about")
def about():
    return {
        "message": "Hello from the about page"
    }


