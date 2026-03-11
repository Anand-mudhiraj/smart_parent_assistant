from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .ml_service import predict_reason

@api_view(['POST'])
def analyze_situation(request):
    try:
        # 1. Get the data sent from Flutter
        parent_input = request.data
        
        # 2. Pass it to your ML model logic
        result = predict_reason(parent_input)
        
        # 3. Send the response back
        return Response({
            "status": "success",
            "data": result
        }, status=status.HTTP_200_OK)
        
    except Exception as e:
        return Response({
            "status": "error",
            "message": str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
