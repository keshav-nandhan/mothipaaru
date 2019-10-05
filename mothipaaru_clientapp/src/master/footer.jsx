import React, { Component } from 'react'

class Footer extends Component {
    render() {
        return (
            <div>
                
                <footer className="footer-distributed">
 
 <div className="footer-left">
{/* <img src="img/logo.png"/> */}
     <h3>About<span> US</span></h3>

     {/* <p class="footer-links">
         <a href="#">Home</a>
         |
         <a href="#">Blog</a>
         |
         <a href="#">About</a>
         |
         <a href="#">Contact</a>
     </p> */}

 </div>

 <div className="footer-center">
     <div>
         <i className="fa fa-map-marker"></i>
           <p><span>Pallikaranai</span>
             Chennai-600100</p>
     </div>

     <div>
         <i className="fa fa-phone"></i>
         <p>+91 9791591592</p>
     </div>
     <div>
         <i className="fa fa-envelope"></i>
         <p><a href="mailto:keshavthehellrider@gmail.com">support@dummy.com</a></p>
     </div>
 </div>
 <div className="footer-right">
     <p className="footer-company-about">
         <span>About the company</span>
         Ready to Accept the Challenge</p>
     <div className="footer-icons">
         <a href="#"><i className="fa fa-facebook"></i></a>
         <a href="#"><i className="fa fa-twitter"></i></a>
         <a href="#"><i className="fa fa-instagram"></i></a>
         <a href="#"><i className="fa fa-linkedin"></i></a>
         <a href="#"><i className="fa fa-youtube"></i></a>
     </div>
 </div>
</footer>

            </div>
        )
    }
}

export default Footer;