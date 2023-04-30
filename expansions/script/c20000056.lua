--无亘龙 古戈尔普勒克斯
if not pcall(function() require("expansions/script/c20000052") end) then require("script/c20000052") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=fuef.SC(c,nil,EVENT_BATTLE_DESTROYING,nil,"M",nil,aux.bdocon,cm.op1)
	local e2={fu_imm.give(c,e1,nil,aux.FALSE)}
	local e3=fuef.FC(c,nil,EFFECT_DESTROY_REPLACE,nil,"G",m,nil,cm.op3,c)
	fuef.Set(e3,{"TG",cm.tg3},{"VAL",cm.val3})
end
--e1
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	local g=fugf.SelectFilter(1-tp,"HMS",nil,nil,nil,1)
	if #g==0 then return end
	Duel.Destroy(g,REASON_EFFECT)
end
--e3
local cm.f3="IsTyp+IsRace+IsControler+IsReason+IsFaceup+IsOnField"
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and fugf.Filter(eg,cm.f3,{"RI+M",RACE_DRAGON,tp,"EFF+BAT-REP"},nil,1)
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.val3(e,c)
	return fucf.Filter(c,cm.f3,"RI+M",RACE_DRAGON,e:GetHandlerPlayer(),"EFF+BAT-REP")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end