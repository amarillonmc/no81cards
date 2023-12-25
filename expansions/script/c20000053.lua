--无亘龙 农兰
xpcall(function() dofile("expansions/script/c20000052.lua") end,function() dofile("script/c20000052.lua") end)
local cm = self_table
function cm.initial_effect(c)
	aux.AddCodeList(c,20000051)
	fu_imm.give(cm,"SH","SC",EVENT_BATTLED,",,M,1,,op1")(c)
end
--e1
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d==c then d=Duel.GetAttacker() end
	if d and d:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsType(TYPE_EFFECT) and not c:IsStatus(STATUS_BATTLE_DESTROYED) then
		_ = fuef.S(c,d,EFFECT_DISABLE) + "RES:EV+STD"
	end
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"D","IsTyp+AbleTo","RI+S,H",1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2tg1(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_DRAGON) and sumtype==SUMMON_TYPE_RITUAL
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=fugf.SelectFilter(tp,"D","IsTyp+AbleTo","RI+S,H"):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	if not tc:IsSetCard(0x3fd0) then fuef.F(e,tp,EFFECT_CANNOT_SPECIAL_SUMMON,",PTG,,1+0,,,,op2tg1,,PH/ED") end
end