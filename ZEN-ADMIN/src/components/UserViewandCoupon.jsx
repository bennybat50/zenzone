

function UserViewandCoupon(){
    return (
        <>
        <div className="container d-flex justify-content-between grid gap-0 column-gap-3 pt-3 bg-light">
            <div className="coupon w-75">
            <div className="container bg-white d-flex justify-content-between pt- pb-1 border-bottom">
            <div className="fs-5 bg-white">
                <p className="pt-2">Userview</p>
            </div>
            <div className="pt-2">
            <select className="form-select" aria-label="Default select example ">
            <option selected>Open this select menu</option>
            <option value="1">One</option>
            <option value="2">Two</option>
            <option value="3">Three</option>
            </select>
            </div>
        </div>
        <div className="container analysischart text-center pt-5">
        analysischart here
        </div>
        </div>
        <div className="coupon w-25 container">
            <div className="d-flex justify-content-between border-bottom">
                <div className="pt-2">
                    <p>Generate coupon</p>
                </div>
                <div className="pt-2">
                <button className="reload-btn mb-3 text-balck ">Reload</button>
                </div>
            </div>
            <div className="d-flex justify-content-center coupon-chart p-2">Chart here</div>
            <div className="coupon-code d-flex justify-content-center">
                <div>
                    <p>32u1002311</p>
                </div>
                <div className="text-warning"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| COPY</div>
            </div>
        </div>
        </div>
        </>
        
    )
}

export default UserViewandCoupon;