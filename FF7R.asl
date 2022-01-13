//Credits Mysterion_06_
//Commissioned by Scruffington
//Thanks to everyone who tested it

state("ff7remake_"){
    byte LRT:           0x579D970;                                  //1 in the main loading screens
    byte LRT2:          0x58B7870;                                  //1 in loading screen after cutscenes
    byte chapter:       0x59809F0;                                  //1 when loading a chapter (goes to 255 as byte when a chapter ends
    byte reset:         0x5365C85;                                  // 1 = ingame; 0 = menu
    int BossMaxHP:      0x0597E2D8, 0x8, 0x18, 0x5E8, 0x1C;         //Return the Enemies current Max HP
    int BossCurrentHP:  0x0597E2D8, 0x8, 0x18, 0x5E8, 0x18;         //Returns the Enemies current HP
}

startup{
    //Asks the user to set his timer to game time on livesplit, which is needed for verification
    if (timer.CurrentTimingMethod == TimingMethod.RealTime) // Inspired by the Modern warfare 3 Autosplitter
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier.",
            "LiveSplit | FF7R",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question);
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }

    //Variable initialization
    vars.HPsCur = new int[10];
    vars.HPsMax = new int[10];

    //Difficulty settings for the Boss splits
    settings.Add("MG", false, "Main Game");
    settings.SetToolTip("MG", "Only check one box at a time (The difficulty you are playing");
        settings.Add("BSPE", false, "Boss Splits Easy", "MG");
        settings.Add("BSPN", false, "Boss Splits Normal", "MG");
        settings.Add("BSPH", false, "Boss Splits Hard", "MG");

    settings.Add("Yuffie", false, "Yuffie%");
}

init{
    //Variable initilization
    vars.CompletedSplits = new List<int>();

    vars.ChapterSplits = new List<int>()
    {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22};

    vars.BossSplitsEasy = new List<int>()
    {5188, 4488, 3343, 7092, 18770, 21450, 10276, 23338, 6732, 10771, 43085, 8078, 77484};

    vars.BossSplitsNormal = new List<int>()
    {9432, 8160, 6079, 12894, 34128, 39000, 18683, 42432, 12240, 19584, 78336, 14688, 140880};

    vars.BossSplitsHard = new List<int>()
    {56592, 35370, 15563, 33012, 84888, 94320, 40086, 61308, 17685, 28296, 113184, 21222, 188640};
}

update{
    //Reset the variables, when the timer isnt running
    if(timer.CurrentPhase == TimerPhase.NotRunning){
        vars.completedSplits.Clear();
    }

    for(int i = 0; i < 10; ++i){
        vars.HPsCur[i] = new DeepPointer(0x597E2D8, 0x8, 0x18 + (i * 0x150), 0x5E8, 0x18).Deref<int>(game);
        vars.HPsMax[i] = new DeepPointer(0x597E2D8, 0x8, 0x18 + (i * 0x150), 0x5E8, 0x1C).Deref<int>(game);
    }
}

start{
    if(current.chapter == 1 || current.chapter == 21){
        return true;
    }
}

split{
    //Chapter Splits Main Game & Yuffie%
    if(old.chapter == 255 && vars.ChapterSplits.Contains(current.chapter) && !vars.CompletedSplits.Contains(current.chapter)){
        vars.CompletedSplits.Add(current.chapter);
        return true;
    }

    //Final Split Main Game
    if((current.BossMaxHP == 35836 || current.BossMaxHP == 65157 || current.BossMaxHP == 87246) && current.BossCurrentHP == 0 && old.BossCurrentHP > 1 && current.chapter == 18){
        return true;
    }

    //Final Split Yuffie%
    if((current.BossMaxHP == 39336 || current.BossMaxHP == 71520) && current.BossCurrentHP == 0 && old.BossCurrentHP > 1 && current.chapter == 22 && settings["Yuffie"]){
        return true;
    }

    //Exception split for Hard Mode
    if(settings["BSPH"] && current.chapter == 13 && current.BossMaxHP == 40086 && current.BossCurrentHP == 0 && old.BossCurrentHP >= 1){
        return true;
    }

    //Main splits for Bosses
    //Loop through the Length of the BossHPs
    for(int i = 0; i < vars.HPsCur.Length; i++){
        //Check what setting was chosen (difficulty) and if the given List contains the current Max Boss HP and the current BossHP equals 0 and the completed splits dont contain
        //That value anymore, add the current max boss hp value to the completed list and return the split
        if((settings["BSPE"] && vars.BossSplitsEasy.Contains(vars.HPsMax[i]) || settings["BSPN"] && vars.BossSplitsNormal.Contains(vars.HPsMax[i]) ||
        settings["BSPH"] && vars.BossSplitsHard.Contains(vars.HPsMax[i])) && vars.HPsCur[i] == 0 && !vars.CompletedSplits.Contains(vars.HPsMax[i])){
            vars.CompletedSplits.Add(vars.HPsMax[i]);
            return true;
        }
    }
}

reset{
    if(current.chapter == 255 && current.reset == 0 && current.LRT == 0 && current.LRT2 == 0){
        return true;
    }
}

isLoading{
    if(current.LRT == 1 || current.LRT2 == 1){
        return true;
    } else{
        return false;
    }
}
