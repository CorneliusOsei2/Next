import {init} from "ityped"
import "./topsidebars.css"
import nextLogo from "../../assets/images/nextLogo.png"
import { useEffect, useRef } from "react"
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
import MenuBookIcon from '@mui/icons-material/MenuBook';
import LogoutIcon from '@mui/icons-material/Logout';
import FeedbackIcon from '@mui/icons-material/Feedback';
import CircleNotificationsIcon from '@mui/icons-material/CircleNotifications';
import { Tooltip } from '@mui/material';

const TopSideBars = () => {

    

    return (
        <div className="topsidebars">
            <TopBar></TopBar>
            <Sidebar></Sidebar>
        </div>
    )
}

const Sidebar = () => {
    return (
        <div className="sidebar">
            
            <div className="icons">
                <ul>
                    <li className="sidebar-item">
                        <a href="index.html" title="user icons">
                            <Tooltip title="Profile" placement="right"><AccountCircleIcon className="sidebar-icon" fontSize="large"></AccountCircleIcon></Tooltip>
                        </a>
                    </li>
                    <li className="sidebar-item">
                        <a href="index.html" title="user icons">
                            <Tooltip title="Courses" placement="right"><MenuBookIcon className="sidebar-icon" fontSize="large"></MenuBookIcon></Tooltip>
                        </a>
                    </li>
                    <li className="sidebar-item">
                        <a href="index.html" title="user icons">
                            <Tooltip title="Leave Feedback" placement="right"><FeedbackIcon className="sidebar-icon" fontSize="large"></FeedbackIcon></Tooltip>
                        </a>
                    </li>
                    <li className="sidebar-item">
                        <a href="index.html" title="user icons">
                            <Tooltip title="Logout" placement="right"><LogoutIcon className="sidebar-icon" fontSize="large"></LogoutIcon></Tooltip>
                        </a>
                    </li>

                </ul>
            </div>
        </div>
    )
}

const TopBar = () => {
    return (
        <div className="topbar">
            <div className="next-logo-div">
                <div><img className="next-logo" src={nextLogo} alt="" /></div>
             </div>
             <div className="greet-div text-center">
                Hi, <span className="greet-name">Cornelius</span>
            </div>

            <div className="notification">
                <CircleNotificationsIcon className="notification-icon" style={{fontSize: 50}}></CircleNotificationsIcon>
            </div>
        </div>
        
    )
}

export default TopSideBars