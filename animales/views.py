from rest_framework import viewsets
from .models import Animal, MovimientoEconomico, Tacto, Tratamiento
from .serializers import AnimalSerializer, MovimientoEconomicoSerializer, TactoSerializer, TratamientoSerializer


class AnimalViewSet(viewsets.ModelViewSet):
    queryset = Animal.objects.all()
    serializer_class = AnimalSerializer


class MovimientoEconomicoViewSet(viewsets.ModelViewSet):
    queryset = MovimientoEconomico.objects.all().order_by('-fecha')
    serializer_class = MovimientoEconomicoSerializer


class TactoViewSet(viewsets.ModelViewSet):
    queryset = Tacto.objects.all().order_by('-fecha')
    serializer_class = TactoSerializer

    def perform_create(self, serializer):
        # Asignamos automáticamente un animal existente
        animal = Animal.objects.first()
        serializer.save(animal=animal)


class TratamientoViewSet(viewsets.ModelViewSet):
    queryset = Tratamiento.objects.all().order_by('-fecha')
    serializer_class = TratamientoSerializer

    def perform_create(self, serializer):
        animal = Animal.objects.first()
        serializer.save(animal=animal)
