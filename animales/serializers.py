from rest_framework import serializers
from .models import Animal, MovimientoEconomico, Tacto, Tratamiento

class AnimalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Animal
        fields = '__all__'

class MovimientoEconomicoSerializer(serializers.ModelSerializer):
    class Meta:
        model = MovimientoEconomico
        fields = '__all__'

class TactoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tacto
        fields = '__all__'

class TratamientoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tratamiento
        fields = '__all__'