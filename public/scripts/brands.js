$(document).ready(function() {

    let dataTableColumns = [{
        name: 'brands.name',
        data: 'brands_name'
    }, {
        name: 'brands.description',
        data: 'brands_description',
        render: function(data, type, row, meta) {
            var notif = data.split(".");
            return notif[0];
        }
    }, {
        name: 'key_id',
        data: 'action',
        "orderable": false
    }, ];


    dataTableInit({
        "container": "#table-data",
        "route": "/datatable/brands",
        "columns": dataTableColumns
    });

});