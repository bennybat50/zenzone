
function AnalysisCard(){
    return (
        <>
           <div className="bg-light container d-flex justify-content-between pt-2 pb-5">
                <div className="card-details shadow border-1 bg-white d-flex justify-content-between">
                    <div className="card-details-text">
                        <ul>
                            <li>Played audio files</li>
                            <li>37,543</li>
                            <li>12.54</li>
                        </ul>
                    </div>
                    <div>
                        {/* <p>chart</p> */}
                    </div>
                </div>
                <div className="card-details shadow border-1 bg-white d-flex justify-content-between">
                    <div className="card-details-text">
                        <ul>
                            <li>Users</li>
                            <li>6,443</li>
                            <li>-10.45</li>
                        </ul>
                    </div>
                    <div>
                        {/* <p>chart</p> */}
                    </div>
                </div>
                <div className="card-details shadow border-1 bg-white d-flex justify-content-between">
                    <div className="card-details-text">
                        <ul>
                            <li>Host request</li>
                            <li>5</li>
                            <li>2.7%</li>
                        </ul>
                    </div>
                    <div>
                        {/* <p>chart</p> */}
                    </div>
                </div>
                <div className="card-details shadow border-1 bg-white d-flex justify-content-between">
                    <div className="card-details-text">
                        <ul>
                            <li>Avg. time on app</li>
                            <li>04:20</li>
                            <li>-0.04%</li>
                        </ul>
                    </div>
                    <div>
                        {/* <p>chart</p> */}
                    </div>
                </div>
            </div> 
        </>
    )
}

export default AnalysisCard;