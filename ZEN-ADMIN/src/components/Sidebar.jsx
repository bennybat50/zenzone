import { Link } from "react-router-dom";

function Sidebar() {
    return (
        <>
            <ul className="navbar-nav bg-gradient-white sidebar sidebar-dark accordion" id="accordionSidebar">

                <Link to="/">
                    <a className="sidebar-brand d-flex align-items-center justify-content-center" x>
                        <div className="sidebar-brand-text mx-3 text-dark">ZENZONE</div>
                    </a>
                </Link>
                <hr className=" my-0" />
                <li className="nav-item active">
                    <Link className="nav-link" to="/">
                        <i className="fas fa-fw fa-tachometer-alt"></i>
                        <span>Dashboard</span></Link>
                </li>


                <Link to="/contentPage">
                    <li className="nav-item">
                        <a className="nav-link collapsed" data-toggle="collapse" data-target="#collapseTwo"
                            aria-expanded="true" aria-controls="collapseTwo">
                            <i class="fas fa-fw fa-cog"></i>
                            <span>Content</span>
                        </a>
                    </li>
                </Link>

                <Link to="/createInterest">
                    <li className="nav-item">
                        <a className="nav-link collapsed" data-toggle="collapse" data-target="#collapseTwo"
                            aria-expanded="true" aria-controls="collapseTwo">
                            <i class="fas fa-fw fa-cog"></i>
                            <span>Interest</span>
                        </a>
                    </li>
                </Link>

                <Link to="/users">
                <li className="nav-item">
                    <a className="nav-link collapsed"data-toggle="collapse" data-target="#collapseUtilities"
                        aria-expanded="true" aria-controls="collapseUtilities">
                        <i class="fas fa-fw fa-wrench"></i>
                        <span>Users</span>
                    </a>

                </li>
                </Link>

                <Link to="/hostrequest">
                    <li className="nav-item">
                        <a className="nav-link collapsed" data-toggle="collapse" data-target="#collapseTwo"
                            aria-expanded="true" aria-controls="collapseTwo">
                            <i class="fas fa-fw fa-cog"></i>
                            <span>Host Request</span>
                        </a>
                    </li>
                </Link>

                <li className="nav-item">
                    <a className="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilities"
                        aria-expanded="true" aria-controls="collapseUtilities">
                        <i className="fas fa-fw fa-wrench"></i>
                        <span>Feed backs</span>
                    </a>
                </li>

            </ul>
        </>
    )
}

export default Sidebar;
