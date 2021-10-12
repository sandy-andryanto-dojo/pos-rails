$(document).ready(function() {

    let dataTableColumns = [{
        name: 'users.username',
        data: 'users_username'
    }, {
        name: 'users.email',
        data: 'users_email'
    }, {
        name: 'users.groups',
        data: 'users_groups',
        render: function(data, type, row, meta) {
            return data ? data : "-";
        }
    }, {
        name: 'key_id',
        data: 'action',
        "orderable": false
    }, ];


    dataTableInit({
        "container": "#table-data",
        "route": "/datatable/users",
        "columns": dataTableColumns
    });

    if ($("#role_ids_").length) {
        $("#role_ids_").select2({
            theme: "bootstrap",
        });
    }

});