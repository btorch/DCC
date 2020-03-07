#!/bin/bash
gunicorn -w 3 --bind 0.0.0.0:8000 dicocel-portal.app
