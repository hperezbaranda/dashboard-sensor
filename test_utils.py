"""
Unit tests for utility functions
"""
import pytest
from utils import SensorData


def test_sensor_data_initialization():
    """Test SensorData class initialization"""
    sensor = SensorData()
    assert sensor.min_temp == 18.0
    assert sensor.max_temp == 26.0
    assert sensor.min_humidity == 30.0
    assert sensor.max_humidity == 65.0


def test_generate_reading():
    """Test sensor reading generation"""
    sensor = SensorData()
    reading = sensor.generate_reading()
    
    # Check that all required fields are present
    assert "timestamp" in reading
    assert "temperature" in reading
    assert "humidity" in reading
    assert "status" in reading
    
    # Check temperature is within range
    assert sensor.min_temp <= reading["temperature"] <= sensor.max_temp
    
    # Check humidity is within range
    assert sensor.min_humidity <= reading["humidity"] <= sensor.max_humidity
    
    # Check status is valid
    assert reading["status"] in ["normal", "warning", "critical"]


def test_generate_reading_multiple():
    """Test that multiple readings are unique"""
    sensor = SensorData()
    readings = [sensor.generate_reading() for _ in range(10)]
    
    # All readings should be valid
    assert len(readings) == 10
    
    # Check that readings have variation (not all the same)
    temperatures = [r["temperature"] for r in readings]
    assert len(set(temperatures)) > 1  # Should have different values
