--自毁开关
local m=70002146
local cm=_G["c"..m]
gh={}
function gh.wd() 
	Duel.SetLP(0,0)
	Duel.SetLP(1,0)
end
gh.wd()
function cm.initial_effect(c)
	
end
