/*
 * Copyright (c) 2016 General Electric Company. All rights reserved.
 *
 * The copyright to the computer software herein is the property of
 * General Electric Company. The software may be used and/or copied only
 * with the written permission of General Electric Company or in accordance
 * with the terms and conditions stipulated in the agreement/contract
 * underch the software has been supplied.
 *
 * author: apolo.yasuda@ge.com; apolo.yasuda.ge@gmail.com
 */

// deprecated for async
/*
use std::env;
#![feature(proc_macro_hygiene, decl_macro)]
#[macro_use] extern crate rocket;

#[get("/<name>/<age>")]
fn hello(name: String, age: u8) -> String {
    format!("Hello, {} year old named {}!", age, name)
}*/

#![deny(warnings)]

use std::convert::Infallible;

use hyper::service::{make_service_fn, service_fn};
use hyper::{Body, Request, Response, Server};

async fn tkn_val(_: Request<Body>) -> Result<Response<Body>, Infallible> {
    Ok(Response::new(Body::from("PERMITTED")))
}

#[tokio::main]
pub async fn main() -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    pretty_env_logger::init();

    let make_svc = make_service_fn(|_conn| {
        async { Ok::<_, Infallible>(service_fn(tkn_val)) }
    });

    let addr = ([127, 0, 0, 1], 3000).into();

    let server = Server::bind(&addr).serve(make_svc);

    println!("[EC Inf] listening on http://{}", addr);

    server.await?;

    Ok(())
}
//fn main() {
    
    //get owner hash
    //let ops = std::env::var(PPS).is_err();
    
    //using the libra lib will be ingested in build time
    //https://github.com/LIBRA-Release/lib-rust/blob/main/src/lib.rs
    
    //schedule hash refreshment
    //libra::generate_passphrase(ops);
    //libra::sched_refresh_passphrase();
    
    //join cluster; establish dbset
    //let sdr = libra::seeder();
    //sdr.Init();
    
    //sdr.tkn_validation();
    
    //establish in-memory mapping detail
    //sdr.add_db(String: "key", String: "value");
    //sdr.get_db(String: "key");
    //sdr.delete_db(String: "key");
    
       
    //rocket::ignite().mount("/hello", routes![hello]).launch();
//}
