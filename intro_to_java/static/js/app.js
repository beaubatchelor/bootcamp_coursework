// from data.js
const tableData = data;

// from index.html
var tbody = d3.select('tbody')

var button = d3.select('#filter-btn');


function dateFilter(date){
    return date >= fieldText
};

function makeData(data){
    tbody.html('');
    data.forEach(function(entry){
        tbody.append("tr");
        Object.entries(entry).forEach(function([key, value]){
            tbody.append('td').text(value);
        });
    });
};

makeData(tableData);

function buttonClicks() {
    let fieldText = d3.select('#datetime').property("value")
    let newData = tableData;
    if (fieldText) {
        newData = newData.filter(row => {
            return row.datetime === fieldText;
        });
    };
    makeData(newData)
};

button.on('click', buttonClicks);