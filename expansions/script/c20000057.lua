--梦幻暗物质
if not pcall(function() require("expansions/script/c20000000") end) then require("script/c20000000") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20000050)
	local e1=fuef.S(c,nil,EFFECT_CANNOT_SSET,nil,nil,nil,nil,nil,nil,c)
	local e2=fuef.F(c,nil,EFFECT_TO_GRAVE_REDIRECT,"IG+AR+SET","S","A+A",LOCATION_REMOVED,nil,nil,cm.tg2,nil,c)
	local e3=fuef.QO(c,nil,nil,nil,"TG","S",1,nil,nil,cm.tg3,cm.op3,c)
end
--e2
function cm.tg2(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
--e3
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return fucf.Filter(chkc,"IsTyp+IsRace+IsLoc+IsControler+IsFaceup","RI+M","M",tp,RACE_DRAGON) end
	if chk==0 then return fugf.GetFilter(tp,"M","IsTyp+IsRace+TgChk+IsFaceup",{"RI+M",RACE_DRAGON,e},nil,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	fugf.SelectTg(tp,"M","IsTyp+IsRace+TgChk+IsFaceup",{"RI+M",RACE_DRAGON,e},nil,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsFaceup() and tc:IsRelateToEffect(e)) then return end
	local e1=fuef.S(e,nil,EFFECT_PIERCE,"CD",nil,nil,nil,nil,nil,tc,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	local e4=fuef.Clone(e1,tc,{"COD",EFFECT_IMMUNE_EFFECT},{"PRO","CD+SR"},{"RAN","M"},{"VAL",cm.op3val4},{"CON",cm.op3con3})
end
function cm.op3val4(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function cm.op3con3(e)
	local ph=Duel.GetCurrentPhase()
	return not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
