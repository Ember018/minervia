from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError as DjangoValidationError # Rename to avoid confict
from .models import Profile

class RegisterSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)
    password = serializers.CharField(required=True, write_only=True)
    password2 = serializers.CharField(required=True, write_only=True)

    def validate_username(self, value):
        """
        Check if username is already exists
        """
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError("Username already exists! Please use another username.")
        return value

    def validate_email(self, value):
        """
        Check if email is already existss
        """
        if User.objects.filter(email__iexact=value).exists(): # Case-insensitive check
            raise serializers.ValidationError("Email already exists! Please use another email")
        return value

    def validate(self, attrs):
        """
        Check if password and password2 match
        """
        password = attrs.get('password')
        password2 = attrs.get('password2')

        if password != password2:
            raise serializers.ValidationError("Password fields does not match!")

        if password:
            try:
                validate_password(password)
            except DjangoValidationError as e:
                raise serializers.ValidationError(f"Password validaiton error: {e.messages}")

        return attrs

    def create(self, validated_data):
        """
        Create and return a new 'User' instance with the validated data.
        Create a new associated Profile
        """
        validated_data.pop('password2')

        user = User.objects.create_user(
            username = validated_data['username'],
            email = validated_data['email'],
            password = validated_data['password'],
        )

        Profile.objects.create(user=user, xp=0, coins=0, hp=100)

        return user
