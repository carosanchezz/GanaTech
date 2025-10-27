from django.db import models

class Animal(models.Model):
    TIPO_CHOICES = [
        ('Vaca', 'Vaca'),
        ('Ternero', 'Ternero'),
        ('Novillo', 'Novillo'),
    ]

    caravana = models.CharField(max_length=50, null=True, blank=True, unique=True)
    peso = models.FloatField()
    sexo = models.CharField(max_length=20)
    estado_reproductivo = models.CharField(max_length=50, null=True, blank=True)
    estado_productivo = models.CharField(max_length=50, null=True, blank=True)
    tipo_animal = models.CharField(max_length=20, choices=TIPO_CHOICES, default='Vaca')
    fecha_registro = models.DateTimeField(auto_now_add=True)
    salida = models.DateField(null=True, blank=True)  # 🆕 Campo opcional para fecha de salida

    def __str__(self):
        return f"{self.caravana or 'Sin Caravana'} - {self.tipo_animal} ({self.sexo})"

class MovimientoEconomico(models.Model):
    TIPO_CHOICES = [
        ('Ingreso', 'Ingreso'),
        ('Gasto', 'Gasto'),
    ]

    fecha = models.DateField()
    tipo = models.CharField(max_length=10, choices=TIPO_CHOICES)
    concepto = models.CharField(max_length=100)
    monto = models.DecimalField(max_digits=12, decimal_places=2)
    creado_en = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.tipo} - {self.concepto} (${self.monto})"
    
class Tacto(models.Model):
    PREÑEZ_CHOICES = [
        ('Preñada', 'Preñada'),
        ('Vacía', 'Vacía'),
        ('En duda', 'En duda'),
    ]
    OVARIOS_CHOICES = [
        ('Sin alteraciones', 'Sin alteraciones'),
        ('Con alteraciones', 'Con alteraciones'),
    ]

    animal = models.ForeignKey(Animal, on_delete=models.CASCADE)
    fecha = models.DateField()
    prenez = models.CharField(max_length=20, choices=PREÑEZ_CHOICES)
    ovarios = models.CharField(max_length=30, choices=OVARIOS_CHOICES)
    observaciones = models.TextField(blank=True, null=True)
    creado_en = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Tacto - {self.animal.caravana or 'Sin ID'} ({self.fecha})"

class Tratamiento(models.Model):
    animal = models.ForeignKey(Animal, on_delete=models.CASCADE)
    fecha = models.DateField()
    condicion = models.CharField(max_length=50)
    medicacion = models.CharField(max_length=50)
    dosis = models.CharField(max_length=50, blank=True, null=True)
    observaciones = models.TextField(blank=True, null=True)
    realizado_por = models.CharField(max_length=100, blank=True, null=True)
    creado_en = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Tratamiento - {self.animal.caravana or 'Sin ID'} ({self.medicacion})"
