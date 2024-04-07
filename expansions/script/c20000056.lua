--无亘龙 潘查万
xpcall(function() dofile("expansions/script/c20000052.lua") end,function() dofile("script/c20000052.lua") end)
local cm, m = GetID()
function cm.initial_effect(c)
	fu_imm.give(cm, "", fuef.SC(nil, EVENT_BATTLE_DESTROYING):RAN("M"):Func("bdocon,op1"))(c)
	fuef.FC(c,EFFECT_DESTROY_REPLACE):RAN("G"):CTL(m):Func("val3,tg3,op3")
end
--e1
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if #fugf.Get(1-tp,"HMS") == 0 then return end
	Duel.Hint(HINT_CARD, tp, m)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	local g=fugf.SelectFilter(1-tp,"HMS")
	if #g==0 then return end
	Duel.Destroy(g,REASON_EFFECT)
end
--e3
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and fugf.Filter(eg,"IsTyp+IsRac+IsRea+IsPos+IsLoc+IsControler",{"RI+M,DR,EFF/BAT-REP,FU,M",tp},1) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.val3(e,c)
	return fucf.Filter(c,"IsTyp+IsRac+IsRea+IsPos+IsLoc+IsControler",{"RI+M,DR,EFF/BAT-REP,FU,M",e:GetHandlerPlayer()})
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end