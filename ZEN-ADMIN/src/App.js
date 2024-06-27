// import logo from './logo.svg';
import { BrowserRouter, Route, Routes } from 'react-router-dom';
import './App.css';
import Index from './pages';
import ContentPage from './pages/Content-Page';
import InterestPage from './pages/InterestPage';
import HostRequest from './pages/HostRequest';
import Users from './pages/Users';


function App() {  

  return (
    <div className="App">
      <BrowserRouter>
        <Routes>
          <Route path='/' element={<Index/>}/>
          <Route path='contentPage' element={<ContentPage/>} component={ContentPage} />
          <Route path='createInterest' element={<InterestPage/>}/>
          <Route path='hostrequest' element={<HostRequest/>}/>
          <Route path='users' element={<Users/>}/>

         
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
