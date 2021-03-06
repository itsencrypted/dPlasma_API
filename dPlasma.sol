pragma solidity 0.6.4;
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";


contract dPlasma {
    // state variables

    enum BloodTypes {
        A_Plus,
        A_Minus,
        B_Plus,
        B_Minus,
        AB_Plus,
        AB_Minus,
        O_Plus,
        O_Minus
    }

    // ERC721Mintable tokenContract;

    struct Donor {
        address donorAddress;
        string city;
        BloodTypes bloodType;
        uint256 birthDate;
        //person must be between 18 and 50
        // uint256 bodyWeight;
        //person must be heavier than 110 llbs (50kg) to donate
        bool hasNotDonatedLastFourWeeks;
        //if true (and we want TRUE) >>> person can donate. If date is less than 4 weeks, person is not available to donate
        bool serologicalTestIsPositive;
        //if true (and we want TRUE)>>> person has antibodies, if false, not eligible to do clinical trials or donate plasma for CPP
        bool pcrResultIsNegative;
        //if true (and we want TRUE)>>> person is not infected with SARS-Covid-19, if false, person tested positive hence, person has the virus and cant donate plasma for CPP
        // bool isActive;
        // //person didn't donate in the past 30 days and can donate again
        bool isMale;
        // bool hadAnyPregnanciesorMiscarriagesMoreThanTwiceIsTrue;
        //if true >>> risks of TRALI (transfusion-related acute lung injury), person can't donate plasma or she might kill the patient of lung complication
        // uint256 lastTattoo;
        //if date is less than 12 months from now, person can't donate
    }
    mapping(address => Donor) public donors;

    struct Patient {
        address patientAddress;
        string patient;
        string hospital;
        string city;
        BloodTypes bloodType;
        bool isINDregistered;
        //Investigational New Drug (IND) >> sick/terminal patients or family members must sign
        //https://www.nybc.org/donate-blood/covid-19-and-blood-donation-copy/convalescent-plasma-information-family-patient-advocates/
    }
    mapping(address => Patient) public patients;

    struct BloodBank {
        address bloodbankAddress;
        string bloodbankName;
        string city;
        //https://www.nybc.org/donate-blood/covid-19-and-blood-donation-copy/convalescent-plasma/
    }
    mapping(address => BloodBank) public bloodBanks;

    struct Hospital {
        address hospitalAddress;
        string hospital;
        string city;
    }
    mapping(address => Hospital) public hospitals;

    struct Doctor {
        address doctorAddress;
        string doctorName;
        string hospital;
    }
    mapping(address => Doctor) public doctors;

    struct Hematologist {
        address hematologistAddress;
        string hematologistName;
        bool ishematologistDoctor;
        string city;
    }
    mapping(address => Hematologist) public hematologists;

    struct Donation {
        uint256 startDate;
        bool hasDonated;
        address donorAddress;
        address bloodbankAddress;
    }
    mapping(uint256 => Donation) public donations;
    uint256 public donationCount;

    // events
    event NewDonor( 
        address donorAddress, string city, BloodTypes bloodType, 
        uint256 birthDate, bool hasNotDonatedLastFourWeeks, bool serologicalTestIsPositive,
         bool pcrResultIsNegative, bool isMale
        );
    event DonorChanges(
        address donorAddress,
        string city,
        bool hasNotDonatedLastFourWeeks
    );
    event NewPatient(address patientAddress, string patient, string city, string hospital, BloodTypes bloodType, bool isINDregistered);
    event NewBloodBank(address bloodbankAddress, string bloodbankName, string city);
    event NewHospital(address hospitalAddress, string hospital, string city);
    event NewDoctor (address doctorAddress, string doctorName, string hospital);
    event NewHematologist (address hematologistAddress, string hematologistName, bool ishematologistDoctor, string city);
    event Donated(address patientAddress, address donorAddress);
    event DonationHappened(uint256 id);

    // functions
    // constructor (address _tokenAddress) public {
    //     tokenContract = ERC721Mintable(_tokenAddress);
    // }

    function donorSignup(
        string memory city,
        BloodTypes bloodType,
        uint256 birthDate,
        bool hasNotDonatedLastFourWeeks, 
        bool serologicalTestIsPositive,
        bool pcrResultIsNegative,
        bool isMale
        ) public {
     
        Donor memory newDonor = Donor(
            msg.sender,
            city,
            bloodType,
            birthDate,
            hasNotDonatedLastFourWeeks,
            serologicalTestIsPositive,
            pcrResultIsNegative,
            isMale);

        donors[msg.sender] = newDonor;

        emit NewDonor(msg.sender, city, bloodType, birthDate, hasNotDonatedLastFourWeeks, serologicalTestIsPositive, pcrResultIsNegative, isMale);
    }

    function donorChanges(
        string memory city,
        bool hasNotDonatedLastFourWeeks
    ) public {
        require(
            donors[msg.sender].donorAddress != address(0),
            "Donor not found."
        );
        // criou um storage pointer
        Donor storage donor = donors[msg.sender];
        donor.city = city;
        donor.hasNotDonatedLastFourWeeks = hasNotDonatedLastFourWeeks;
        emit DonorChanges(msg.sender, city, hasNotDonatedLastFourWeeks);
    }

    function patientSignup(
        string memory patient,
        string memory hospital,
        string memory city,
        BloodTypes bloodType,
        bool isINDregistered) public {
    
        Patient memory newPatient = Patient(
            msg.sender,
            patient,
            hospital,
            city,
            bloodType,
            isINDregistered);
            
        patients[msg.sender] = newPatient;

        emit NewPatient(msg.sender, patient, hospital, city, bloodType, isINDregistered);
    }
    
    function hospitalSignup(string memory hospital, string memory city) public {

        Hospital memory newHospital = Hospital(msg.sender, hospital, city);

        hospitals[msg.sender] = newHospital;

        emit NewHospital(msg.sender, hospital, city);
    }
    
    function doctorSignup(string memory hospital, string memory doctorName) public {

        Doctor memory newDoctor = Doctor(msg.sender, doctorName, hospital);

        doctors[msg.sender] = newDoctor;

        emit NewDoctor(msg.sender, doctorName, hospital);
    }
    
    function hematologistSignup(bool ishematologistDoctor, string memory hematologistName, string memory city) public {

        Hematologist memory newHematologist = Hematologist(msg.sender, hematologistName, ishematologistDoctor, city);

        hematologists[msg.sender] = newHematologist;

        emit NewHematologist(msg.sender, hematologistName, ishematologistDoctor, city);
    }


    function bloodbankSignup(string memory bloodbankName, string memory city) public {

        BloodBank memory newBloodBank = BloodBank(msg.sender, bloodbankName, city);

        bloodBanks[msg.sender] = newBloodBank;

        emit NewBloodBank(msg.sender, bloodbankName, city);
    }

    // donations scheduled
    // called by donors
    function donationScheduled(address bloodbankAddress) public {
        require(
            donors[msg.sender].donorAddress != address(0),
            "Caller is not a donor"
        );
        require(bloodBanks[bloodbankAddress].bloodbankAddress != address(0), "Blood Bank does not exist");

        // criou o struct na memória
        Donation memory newDonation = Donation(
            now,
            false,
            msg.sender,
            address(0)
        );
        donationCount++;
        // gravou o struct no mapping (estado)
        donations[donationCount] = newDonation;
        // 2do event
        emit Donated(msg.sender, bloodbankAddress);
    }

    modifier onlyBloodBank {
        require(
            bloodBanks[msg.sender].bloodbankAddress != address(0),
            "Caller is not a blood bank"
        );
        _;
    }

    // donations executed
    // called by banks only
    function donationHappened(uint256 donationId) public onlyBloodBank {
        Donation storage donation = donations[donationId];
        require(donation.startDate != 0, "Donation not found");
        require(donation.hasDonated == false, "Donation has already happened");

        donation.hasDonated = true;
        donation.bloodbankAddress = msg.sender;

        // event
        emit DonationHappened(donationId);

        // // issue NFT to donor
        // tokenContract.mint(donation.donorAddress, donationId);
    }
}
