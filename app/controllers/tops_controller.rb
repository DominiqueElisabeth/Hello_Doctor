class TopsController < ApplicationController
  def index
  end

  def guest_sign_in
    patient = Patient.find_or_create_by!(email: 'test@example.com') do |patient|
      patient.name = "test"
      patient.password = SecureRandom.urlsafe_base64
    end
    sign_in patient
    redirect_to root_path, notice: 'You have logged in as a patient'
  end

  def guest_admin_sign_in
    doctor = Doctor.find_or_create_by!(name: "admin") do |doctor|
      doctor.admin = true
      doctor.password = SecureRandom.urlsafe_base64
    end
    sign_in doctor
    redirect_to root_path, notice: 'You have logged in as an admin'
  end
end
