--圣沌大忍者 波罗羯谛
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000175") end) then require("script/c20000175") end
function cm.initial_effect(c)
	fu_HC.glo(c)
	local e1=fuef.FTF(c,c,",",EVENT_PHASE+PHASE_BATTLE_START,",M",1,cm.con1,",",cm.op1)
	local e2=fuef.F(c,c,"",m,"PTG,M,1+0")
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=fugf.Get(tp,"+M")
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	end
	local e1=fuef.F(e,tp,"",EFFECT_MUST_ATTACK,",,+M,,,,,",RESET_PHASE+PHASE_END)
end