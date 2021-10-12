$(document).ready(function() {

    let dataTableColumns = [{
            name: 'suppliers.name',
            data: 'suppliers_name'
        }, {
            name: 'suppliers.phone',
            data: 'suppliers_phone'
        }, {
            name: 'suppliers.email',
            data: 'suppliers_email'
        },
        {
            name: 'suppliers.website',
            data: 'suppliers_website'
        }, {
            name: 'key_id',
            data: 'action',
            "orderable": false
        },
    ];


    dataTableInit({
        "container": "#table-data",
        "route": "/datatable/suppliers",
        "columns": dataTableColumns
    });

});