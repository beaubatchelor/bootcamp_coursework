// datetime: "1/1/2010",
// city: "benton",
// state: "ar",
// country: "us",
// shape: "circle",
// durationMinutes: "5 mins.",
// comments: "4 bright green"


// from data.js
const tableData = data;

// from index.html
var tbody = d3.select('tbody')

var field = d3.select('#datetime')

var button = d3.select('#filter-btn');

// clear old data
tbody.html('')

tableData.forEach(function(data){
    Object.entries(data).forEach(function([key, value]){
        tbody.append('td').text(value);
    });
});

// button function
function buttonClick(){
    button.on('click', function(e){
        let fieldText = document.querySelector('#datetime').value;
        alert(fieldText);
        tbody.html('')
        tableData.forEach(function(data){
            tbody.append('tr');
            Object.entries(data).forEach(function([key, value]){
                if (value === fieldText)
                tbody.append('td').text(value);
            });
        });
    })
};




buttonClick()
