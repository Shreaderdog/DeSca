import React from 'react';
import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend,
  } from 'chart.js';
  import { Line } from 'react-chartjs-2';

  ChartJS.register(
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
  );

  const sensorgraph = (input) => {

    let labelinfo = input.labelinfo;
    let datapoints = input.datapoints;
    const options = {
        responsive: true,
        plugins: {
          legend: {
            position: 'top',
          },
          title: {
            display: true,
            text: labelinfo.title,
          },
        },
    };

    const labels = labelinfo.labels;

    const data = {
        labels,
        datasets: [
            {
                data: datapoints,
                borderColor: 'rgb(255, 0, 0)',
                backgroundCOlor: 'rgb(255, 0, 0)'
            }
        ]
    }

    return <Line options={options} data={data} />;
  }

  export default sensorgraph;