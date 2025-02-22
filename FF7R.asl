//Credits Mysterion352
//Commissioned by Scruffington
//Thanks to everyone who tested it
//Thanks to DesertEagle417 for creating the Yuffie section
//Thanks to Qwazerty for updating the asl - Added Steam version support
//Updated 20.06.2023 - Thanks to NanakiEmi for finding the new LRT, LRT2, chapter and reset pointer for Epic Version
//Updated 15.08.2024 - Added newest Steam Support - Mysterion352
//Updated 20.2.2025 - Updated for 1.0.0.4 for Steam and EGS - Denhonator

state("ff7remake_", "v1.0.0.1 (Steam)"){
    byte LRT:           0x57B94F0;                                  //1 in the main loading screens
    byte LRT2:          0x58D33F0;                                  //1 in loading screen after cutscenes
    byte chapter:       0x599C6B0;                                  //1 when loading a chapter (goes to 255 as byte when a chapter ends)
    byte reset:         0x599C6CD;                                  //1 = ingame; 0 = menu
    int BossMaxHP:      0x5999F98, 0x8, 0x18, 0x5E8, 0x1C;          //Returns the Enemies current Max HP
    int BossCurrentHP:  0x5999F98, 0x8, 0x18, 0x5E8, 0x18;          //Returns the Enemies current HP
}

state("ff7remake_", "v1.0.0.0 (Steam)"){
    byte LRT:           0x57A5A70;                                  //1 in the main loading screens
    byte LRT2:          0x58BF970;                                  //1 in loading screen after cutscenes
    byte chapter:       0x5988C20;                                  //1 when loading a chapter (goes to 255 as byte when a chapter ends)
    byte reset:         0x5374210;                                  //1 = ingame; 0 = menu
    int BossMaxHP:      0x5986508, 0x8, 0x18, 0x5E8, 0x1C;          //Returns the Enemies current Max HP
    int BossCurrentHP:  0x5986508, 0x8, 0x18, 0x5E8, 0x18;          //Returns the Enemies current HP
}

state("ff7remake_", "v1.0.0.0 (EGS)"){
    byte LRT:           0x57B1470;                                  //1 in the main loading screens
    byte LRT2:          0x58CB370;                                  //1 in loading screen after cutscenes
    byte chapter:       0x5994530;                                  //1 when loading a chapter (goes to 255 as byte when a chapter ends)
    byte reset:         0x58CB380;                                  //1 = ingame; 0 = menu
    int BossMaxHP:      0x5991E18, 0x8, 0x18, 0x5E8, 0x1C;          //Returns the Enemies current Max HP
    int BossCurrentHP:  0x5991E18, 0x8, 0x18, 0x5E8, 0x18;          //Returns the Enemies current HP
}

state("ff7remake_", "v1.0.0.4 (EGS)"){
    byte LRT:           0x57C3870;                                  //1 in the main loading screens
    byte LRT2:          0x58DD7C8;                                  //1 in loading screen after cutscenes
    byte chapter:       0x59A6AD0;                                  //1 when loading a chapter (goes to 255 as byte when a chapter ends)
    byte reset:         0x58DD7D8;                                  //1 = ingame; 0 = menu
    int BossMaxHP:      0x59A43B8, 0x8, 0x18, 0x5E8, 0x1C;         //Returns the Enemies current Max HP
    int BossCurrentHP:  0x59A43B8, 0x8, 0x18, 0x5E8, 0x18;         //Returns the Enemies current HP
}

state("ff7remake_", "v1.0.0.4 (Steam)"){
    byte LRT:           0x57CA870;                                  //1 in the main loading screens
    byte LRT2:          0x58E47C8;                                  //1 in loading screen after cutscenes
    byte chapter:       0x59ADBF0;                                  //1 when loading a chapter (goes to 255 as byte when a chapter ends)
    byte reset:         0x58E47D8;                                  //1 = ingame; 0 = menu
    int BossMaxHP:      0x59AB4D8, 0x8, 0x18, 0x5E8, 0x1C;         //Returns the Enemies current Max HP
    int BossCurrentHP:  0x59AB4D8, 0x8, 0x18, 0x5E8, 0x18;         //Returns the Enemies current HP
}


startup{
    //Asks the user to set his timer to game time on livesplit, which is needed for verification
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
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
    vars.WolvesFound = false;
    vars.WolvesBeaten = false;

    //Difficulty settings for the Boss splits
    settings.Add("MG", true, "Main Game");
    settings.SetToolTip("MG", "Only check one box at a time (The difficulty you are playing");
        settings.Add("BSPE", false, "Boss Splits Easy", "MG");
        settings.Add("BSPN", false, "Boss Splits Normal", "MG");
        settings.Add("BSPH", false, "Boss Splits Hard", "MG");

    settings.Add("Yuffie", false, "Yuffie%");
    settings.SetToolTip("Yuffie", "Only check one box at a time (The difficulty you are playing");
        settings.Add("YSPE", false, "Yuffie Splits Easy", "Yuffie");
        settings.Add("YSPN", false, "Yuffie Splits Normal", "Yuffie");
        settings.Add("YSPH", false, "Yuffie Splits Hard", "Yuffie");
}

init{
    switch (modules.First().ModuleMemorySize) {
        default:
        version = "v1.0.0.0 (EGS)";
        vars.offset = 0x0;
        break;
        case (99311616):
        version = "v1.0.0.0 (Steam)";
        vars.offset = 0xB910;
        break;
        case (99393536):
        version = "v1.0.0.1 (Steam)";
        vars.offset = 0x8180;
        break;
        case (99438592):
        version = "v1.0.0.4 (EGS)";
        vars.offset = 0;
        break;
		case (99467264):
        version = "v1.0.0.4 (Steam)";
        vars.offset = 0x7120;
        break;
    }

    //print("This is module size: " + modules.First().ModuleMemorySize.ToString());
    //Variable initilization
    vars.CompletedSplits = new List<int>();

    vars.ChapterSplits = new List<int>()
    {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,22};

    vars.BossSplitsEasy = new List<int>()
    {5188, 4488, 3343, 7092, 18770, 21450, 10276, 23338, 10771, 43085, 8078, 77484};

    vars.BossSplitsNormal = new List<int>()
    {9432, 8160, 6079, 12894, 34128, 39000, 18683, 42432, 19584, 78336, 14688, 140880};

    vars.BossSplitsHard = new List<int>()
    {56592, 35370, 15563, 33012, 84888, 94320, 40086, 61308, 28296, 113184, 21222, 188640};

    vars.YuffieSplitsEasy = new List<int>()
    {3941, 11822, 17339, 1409, 5164, 18777, 9834};

    vars.YuffieSplitsNormal = new List<int>()
    {7165, 21495, 31526, 2561, 9389, 34140, 17880};

    vars.YuffieSplitsHard = new List<int>()
    {11790, 35370, 51876, 12969, 47160, 23580};

}

update{
    if(timer.CurrentPhase == TimerPhase.NotRunning){
        vars.CompletedSplits.Clear();
        vars.WolvesFound = false;
        vars.WolvesBeaten = false;
    }

    for(int i = 0; i < 10; ++i){
        vars.HPsCur[i] = new DeepPointer(0x5991E18 + vars.offset, 0x8, 0x18 + (i * 0x150), 0x5E8, 0x18).Deref<int>(game);
        vars.HPsMax[i] = new DeepPointer(0x5991E18 + vars.offset, 0x8, 0x18 + (i * 0x150), 0x5E8, 0x1C).Deref<int>(game);
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
    if((current.BossMaxHP == 35836 || current.BossMaxHP == 65157 || current.BossMaxHP == 87246) &&
        current.BossCurrentHP == 0 && old.BossCurrentHP > 0 && current.chapter == 18 && settings["MG"]){
        return true;
    }

    //Final Split Yuffie%
    if((current.BossMaxHP == 39336 || current.BossMaxHP == 71520 || current.BossMaxHP == 94320) &&
        current.BossCurrentHP == 0 && old.BossCurrentHP > 0 && current.chapter == 22 && settings["Yuffie"]){
        return true;
    }

    //Levrikon exception split for Yuffie%
    if((settings["YSPE"] && current.BossMaxHP == 3941 && vars.CompletedSplits.Contains(3941) ||
        settings["YSPN"] && current.BossMaxHP == 7165 && vars.CompletedSplits.Contains(7165) || 
        settings["YSPH"] && current.BossMaxHP == 11790 && vars.CompletedSplits.Contains(11790)) 
        && current.chapter == 21 && current.BossCurrentHP == 0 && old.BossCurrentHP > 0){
        return true;
    }

    //Exception split for Yuffie Hard Mode (Armored Magitrooper)
    if(settings["YSPH"] && current.chapter == 22 && current.BossMaxHP == 3537 && current.BossCurrentHP == 0 && old.BossCurrentHP > 0){
        return true;
    }

    //Main splits for Bosses
    //Loop through the Length of the BossHPs
    for(int i = 0; i < vars.HPsCur.Length; i++){
        //Check what setting was chosen (difficulty) and if the given List contains the current Max Boss HP and the current BossHP equals 0 and the completed splits dont contain
        //That value anymore, add the current max boss hp value to the completed list and return the split
        if((settings["BSPE"] && vars.BossSplitsEasy.Contains(vars.HPsMax[i]) || 
            settings["BSPN"] && vars.BossSplitsNormal.Contains(vars.HPsMax[i]) ||
            settings["BSPH"] && vars.BossSplitsHard.Contains(vars.HPsMax[i]) || 
            settings["YSPE"] && vars.YuffieSplitsEasy.Contains(vars.HPsMax[i]) || 
            settings["YSPN"] && vars.YuffieSplitsNormal.Contains(vars.HPsMax[i]) ||
            settings["YSPH"] && vars.YuffieSplitsHard.Contains(vars.HPsMax[i])) && 
            vars.HPsCur[i] == 0 && !vars.CompletedSplits.Contains(vars.HPsMax[i])){
                vars.CompletedSplits.Add(vars.HPsMax[i]);
                return true;
        }
    }

    //Yuffie Wolves split exception
    //Make sure we're in correct chapter and check that Wolves aren't already beaten
    if(current.chapter == 21 && !vars.WolvesBeaten){
        vars.EnemiesBeaten = true;

        //Loop through the Length of the BossHPs
        for(int i = 0; i < vars.HPsCur.Length; i++){
            //Search for the MaxHP value corresponding to the wolves to determine if they're in the battle
            if(!vars.WolvesFound && (settings["YSPE"] && vars.HPsMax[i] == 1227 || settings["YSPN"] && vars.HPsMax[i] == 2231 || settings["YSPH"] && vars.HPsMax[i] == 4245)){
                vars.WolvesFound = true;
            }

            //Check for all enemies in the battle being beaten
            if(vars.HPsCur[i] > 0){
                vars.EnemiesBeaten = false;
            }
        }

        //Split if all enemies in the wolves battle are defeated
        if(vars.WolvesFound && vars.EnemiesBeaten){
            vars.WolvesBeaten = true;
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
