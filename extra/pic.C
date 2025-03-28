//Small script to show an image with ROOT... trick to see images @Lyon,  where no viewer is known...

// #include "TImage.h"
// #include "TCanvas.h"
// #include "TArrayD.h"
// #include "TROOT.h"
// #include "TColor.h"
// #include "TAttImage.h"
// #include "TEnv.h"

void pic(string imageFileName="None"){

//   try{
  
    TImage *image = TImage::Open(imageFileName.c_str());

    if(!image){
      cout << "\n > Error with file image \"" << imageFileName << "\"..." << endl;
      return;
    }

    cout << "\n > File: \"" << imageFileName << "\"" << endl << endl;
    cout << "    - Width x Height: " << image->GetWidth() << " x " << image->GetHeight() << endl;
    cout << "    - Compression: " << image->GetImageCompression() << endl;
    cout << endl;

    TCanvas *c1;
    image->Draw();
    
//   }

}
