function buildMetadata(sample) {
  d3.json(`/metadata/${sample}`).then(function(data) {
    let panel = d3.select('#sample-metadata');
    panel.html('');
    Object.entries(data).forEach(function([key, value]) {
      panel.append("h1").text(`${key}: ${value}`);
    });
  });
};

function buildCharts(sample) {
  d3.json(`/samples/${sample}`).then(function(data) {
    let sampleValues = data.sample_values;
    let otuIds = data.otu_ids;
    let otuLabels = data.otu_labels;

    let layout = {
      margin : {t: 0}
    }

    let chartData = [
      {
        x : otuIds,
        y : sampleValues,
        text : otuLabels,
        mode : "markers",
        marker : {
          size : sampleValues,
          color : otuIds
        }
      }
    ];

    Plotly.plot("bubble", chartData, layout)

    let pieData = [
      {
        values : sampleValues.slice(0, 10),
        labels : otuIds.slice(0, 10),
        type : "pie",
        hoverinfo : "hovertext",
        hovertext : otuLabels.slice(0, 10)

      }
    ];

    Plotly.plot("pie", pieData, layout)
  });
}

function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");

  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text(sample)
        .property("value", sample);
    });

    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
}

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);
}

// Initialize the dashboard
init();
