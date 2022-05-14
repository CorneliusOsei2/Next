import {init} from "ityped"
import "./homepage.css"
import profileIcon from "../../assets/images/profileIcon.png"
import { useEffect, useRef } from "react"
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
import MenuBookIcon from '@mui/icons-material/MenuBook';
import LogoutIcon from '@mui/icons-material/Logout';
import FeedbackIcon from '@mui/icons-material/Feedback';
import { Tooltip } from '@mui/material';

const Homepage = () => {

    

    return (
        <div className="homepage">
            <Sidebar></Sidebar>
            <TopPage></TopPage>
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
                            <Tooltip title="Profile" placement="right"><AccountCircleIcon fontSize="large"></AccountCircleIcon></Tooltip>
                        </a>
                    </li>
                    <li className="sidebar-item">
                        <a href="index.html" title="user icons">
                            <Tooltip title="Courses" placement="right"><MenuBookIcon fontSize="large"></MenuBookIcon></Tooltip>
                        </a>
                    </li>
                    <li className="sidebar-item">
                        <a href="index.html" title="user icons">
                            <Tooltip title="Leave Feedback" placement="right"><FeedbackIcon fontSize="large"></FeedbackIcon></Tooltip>
                        </a>
                    </li>
                    <li className="sidebar-item">
                        <a href="index.html" title="user icons">
                            <Tooltip title="Logout" placement="right"><LogoutIcon fontSize="large"></LogoutIcon></Tooltip>
                        </a>
                    </li>

                </ul>
            </div>
        </div>
    )
}

const TopPage = () => {
    const titleRef = useRef()
    const descRef = useRef()

    useEffect(() => {
        init(titleRef.current, {
            typeSpeed: 40,
            showCursor: false,
            strings: ['Corneli className="sidebar-item"us'],
            backDelay: 50000,
        })

        init(descRef.current, {
            typeSpeed: 40,
            showCursor: true,
            backDelay: 50000,
            strings: ['A Computer Science Student at Cornell University interested in solving problems through efficient means! I like learning new stuff and writing code!']
        })
    }, [])

    return (
        <div className="toppage container">
            <div className="row">
                <div className="col-md-6">
                    <div className="about">
                    <h2 ref={titleRef} ></h2>

                    <p ref={descRef}></p>
                    </div>
                </div>

                <div className="col-md-6">
                    <img className="" src={profileIcon} alt="" />
                </div>
            </div>
        </div>
    )
}

export default Homepage