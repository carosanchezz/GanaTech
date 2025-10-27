from django.contrib import admin
from .models import Animal

@admin.register(Animal)
class AnimalAdmin(admin.ModelAdmin):
    list_display = ('caravana', 'peso', 'sexo', 'estado_reproductivo', 'estado_productivo', 'fecha_registro')
