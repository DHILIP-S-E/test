import sys
import os

# Add the current directory to sys.path
sys.path.append(os.path.join(os.getcwd(), "life_os/backend"))

try:
    from app.main import app
    print("Successfully imported app")
except Exception as e:
    print(f"Failed to import app: {e}")
    import traceback
    traceback.print_exc()
