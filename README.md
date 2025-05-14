# Smog Free Tower Plate Charge Density Optimization

## Overview
This project focuses on optimizing the **plate charge density of a Smog Free Tower** using **MATLAB simulations**, with the goal of maximizing particulate removal efficiency via electrostatic attraction.

The simulation models various common air pollutants, including **PM2.5, PM10, NO₂, SO₂, O₃, and CO**, and analyzes their behavior under different air velocities and charge densities.  
It calculates the optimal charge density that maximizes capture rates, estimates air purification effectiveness, and projects the system's theoretical impact on atmospheric cleaning.

---

## Features
- **Multi-pollutant modeling** with custom properties (mass, diameter, concentration, charge).
- **Electrostatic, drag, and Brownian motion forces simulation** for particle capture prediction.
- Iterative simulation of **airflow velocities, plate distances, and charge densities** to find optimal configurations.
- **Estimation of pollutant mass removed, volume of air cleaned, and theoretical atmospheric impact.**

---

## Technologies Used
- MATLAB R2023a (or compatible)
- Numerical simulation of fluid dynamics and electrostatics
- Custom physics modeling functions (net force, trajectory tracking)

---

## Key Algorithms
- Force balance between drag, electrostatic, and Brownian forces.
- Time-stepped particle trajectory simulation to determine if particles are captured before exiting the tower.
- Charge density sweeping to determine the most effective configuration.
- Calculation of mass removal and atmospheric cleaning timescales.

---

## Getting Started

### Requirements
- MATLAB R2023a or newer.

### Running the Simulation
1. Clone the repository.
2. Run the `main.m` script in MATLAB.
3. View the calculated optimal charge density and estimated cleaning effectiveness in the MATLAB console.

### Main Script Components
- `main.m`: Main simulation loop iterating through charge densities, pollutants, and velocities.
- `netForce()`: Function simulating particle capture under given force conditions.
