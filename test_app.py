"""
Unit tests for the dashboard sensor application
"""
import pytest
from fastapi.testclient import TestClient
from app import app

client = TestClient(app)


def test_home_page():
    """Test that the home page loads successfully"""
    response = client.get("/")
    assert response.status_code == 200
    assert "text/html" in response.headers["content-type"]


def test_current_reading():
    """Test the current sensor reading endpoint"""
    response = client.get("/current")
    assert response.status_code == 200
    
    data = response.json()
    assert "timestamp" in data
    assert "temperature" in data
    assert "humidity" in data
    assert "status" in data
    
    # Verify data types and ranges
    assert isinstance(data["temperature"], (int, float))
    assert isinstance(data["humidity"], (int, float))
    assert data["status"] in ["normal", "warning", "critical"," offline"]


# def test_stream_endpoint():
#     """Test that the stream endpoint is accessible"""
#     response = client.get("/stream")
#     assert response.status_code == 200
#     assert "text/event-stream" in response.headers["content-type"]
