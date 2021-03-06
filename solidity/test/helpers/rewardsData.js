const testValues = {
    defaultTimestamps: [
        1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015,
    ],
    initiationTime: 1000,
    termLength: 100,
    totalRewards: 1000000,
    minimumIntervalKeeps: 2,
    rewardTimestamps: [
        1000, 1001, 1099, // interval 0; 0..2
        1100, 1101, 1102, 1103, // interval 1; 3..6
        1234, // interval 2; 7
        1300, 1301, // interval 3; 8..9
        1500, // interval 5; 10
        1600, 1601, // interval 6; 11..12
    ],
    keepsInRewardIntervals: [
        3, 4, 1, 2, 0, 1, 2, 0,
    ],
    //rewardIntervalAdjustments = [...]
    intervalWeights: [
        // percentage of unallocated rewards, allocated : remaining
        20, // 20:80
        50, // 40:40
        25, // 10:30
        50, // 15:15
    ],
    inVacuumBaseRewards: [
        200000, 500000, 250000, 500000, 1000000, 1000000, 1000000,
    ],
    inVacuumAdjustedRewards: [
        199998, 500000, 125000, 500000, 0, 500000, 1000000,
    ],
    inVacuumPerKeepRewards: [
        66666, 125000, 125000, 250000, 0, 500000, 500000,
    ],
    actualAllocations: [
        199998, // 800002 remaining
        400000, // 400002 remaining
        50000,  // 350002 remaining
        175000, // 175002 remaining
        0,
        87501, // 87501 remaining
        87500, // 1 remaining
    ]
}
module.exports = { testValues }
