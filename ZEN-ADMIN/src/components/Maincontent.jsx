import Sidebar from "./Sidebar";
import NavBar from "./NavBar";
import CreateContent from "./CreateContent";

//import AnalysisCard from "./AnalysisCard";
//import UserViewandCoupon from "./UserViewandCoupon";
//import AllUsersandHost from "./AllUsersandHost";
//import SocialMediaTracker from "./SocialMediaTracker";

function Maincontent() {
    return (
        <div style={{width: 100 +  "%"}}>
            <NavBar/>
            <CreateContent/>
        </div>
    )
}
export default Maincontent;