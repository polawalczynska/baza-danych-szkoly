import React, { useState } from 'react';
import './App.css';
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Header from "../Header/Header";
import Body from "../Boody/Body";
import Select from "../Select/Select";
import Home from "../Home/Home";
import Menu from "../Menu/Menu";
import Footer from "../Footer/Footer";
import Run from "../Run/Run";

const App = () => {
    const [loading, setLoading] = useState<boolean>(true);

    return (
        <BrowserRouter>
            <Header />
            <Body isLoading={loading}>
                <Routes>
                    <Route path="/" element={<Home setLoading={setLoading} />} />
                    <Route path="/select/:databaseName" element={<Select setLoading={setLoading} />} />
                    <Route path="/run/:fooParams" element={<Run setLoading={setLoading} />} />
                    <Route path="/menu" element={<Menu setLoading={setLoading} />} />
                    <Route path="/*" element={<div> h x h x h x </div>} />
                </Routes>
            </Body>
            <Footer />
        </BrowserRouter>
    );
}

export default App;
