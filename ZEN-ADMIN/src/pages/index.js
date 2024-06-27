import Maincontent from "../components/Maincontent";
import Sidebar from "../components/Sidebar";

export default function Index() {
    return (<div className="d-flex">
        <Sidebar />
        <Maincontent />
    </div>)
}