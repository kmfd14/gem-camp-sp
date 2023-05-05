import { Controller } from "@hotwired/stimulus"
import $ from 'jquery'

export default class extends Controller {
    static targets = ['selectedRegionId', 'selectedProvinceId','selectedCityId', 'selectedBarangayId']

    fetchProvinces() {
        let target = this.selectedProvinceIdTarget;
        $(target).empty();

        $.ajax({
            type: 'GET',
            url: '/api/v1/regions/' + this.selectedRegionIdTarget.value + '/provinces',
            dataType: 'json',
            success: (response) => {
                $.each(response, function (index, record) {
                    let option = document.createElement('option');
                    option.value = record.id;
                    option.text = record.name;
                    $(target).append(option);
                });
            },
            error: (xhr, status, error) => {
                console.log(xhr, status, error);
            }
        });
    }

    fetchCities() {
        let target = this.selectedCityIdTarget
        $(target).empty()

        $.ajax({
            type: 'GET',
            url: '/api/v1/provinces/' + this.selectedProvinceIdTarget.value + '/cities',
            dataType: 'json',
            success: (response) => {
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }

    fetchBarangays() {
        let target = this.selectedBarangayIdTarget
        $(target).empty()

        $.ajax({
            type: 'GET',
            url: '/api/v1/cities/' + this.selectedCityIdTarget.value + '/barangays',
            dataType: 'json',
            success: (response) => {
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }
}