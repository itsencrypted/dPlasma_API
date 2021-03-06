# Generated by Django 3.0.6 on 2020-05-11 03:40

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('dplasma', '0005_patient'),
    ]

    operations = [
        migrations.CreateModel(
            name='Hematologist',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('complete_name', models.CharField(max_length=255)),
                ('license', models.CharField(max_length=255)),
                ('ethereum_address', models.CharField(max_length=255)),
                ('three_box_profile', models.CharField(max_length=255)),
                ('hospital', models.ForeignKey(on_delete=django.db.models.deletion.DO_NOTHING, related_name='hospital_identification', to='dplasma.Hospital')),
            ],
            options={
                'db_table': 'hematologist',
            },
        ),
        migrations.CreateModel(
            name='Donor',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ethereum_address', models.CharField(max_length=255)),
                ('city', models.CharField(max_length=255)),
                ('birth_date', models.DateField()),
                ('blood_type', models.CharField(max_length=3)),
                ('last_donation', models.DateField()),
                ('serological_test_result', models.CharField(max_length=1)),
                ('date_of_first_symptom', models.DateField()),
                ('date_of_last_symptom', models.DateField()),
                ('pcr_result', models.CharField(max_length=1)),
                ('gender', models.CharField(max_length=1)),
                ('comorbidities_for_donation', models.CharField(max_length=1)),
                ('last_tatoo', models.DateField()),
                ('hematologist_report_blob', models.CharField(max_length=255)),
                ('three_box_profile', models.CharField(max_length=255)),
                ('hematologist_id', models.ForeignKey(on_delete=django.db.models.deletion.DO_NOTHING, related_name='hematologist_id', to='dplasma.Hematologist')),
                ('hospital_id', models.ForeignKey(on_delete=django.db.models.deletion.DO_NOTHING, related_name='hospital_reg', to='dplasma.Hospital')),
            ],
            options={
                'db_table': 'donor',
            },
        ),
    ]
