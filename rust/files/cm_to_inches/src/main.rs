use std::io;

fn main() {
    loop {
        println!("Enter a number.");

        let mut num = String::new();

        io::stdin()
            .read_line(&mut num)
            .expect("Failed to read line");

        let num: f32 = match num.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        let ret: f32 = cm_to_inches(num);

        println!("The value is {:.5}", ret);
    }
}

fn cm_to_inches(value: f32) -> f32 {
   return value / 2.54;
}
