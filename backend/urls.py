from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from animales.views import AnimalViewSet, MovimientoEconomicoViewSet, TactoViewSet, TratamientoViewSet

router = DefaultRouter()
router.register(r'animales', AnimalViewSet)
router.register(r'movimientos', MovimientoEconomicoViewSet)
router.register(r'tactos', TactoViewSet)
router.register(r'tratamientos', TratamientoViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
]
