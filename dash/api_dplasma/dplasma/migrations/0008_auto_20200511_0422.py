# Generated by Django 3.0.6 on 2020-05-11 04:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('dplasma', '0007_remove_donor_ethereum_address'),
    ]

    operations = [
        migrations.AlterField(
            model_name='donor',
            name='city',
            field=models.CharField(default='', max_length=255),
        ),
    ]