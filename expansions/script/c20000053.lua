--无亘龙 农兰
if not pcall(function() require("expansions/script/c20000052") end) then require("script/c20000052") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=fuef.SC(c,nil,EVENT_BATTLED,nil,"M",1,nil,cm.op1)
	local e2={fu_imm.give(c,e1,"SH",cm.tg3,cm.op3)}
end
--e1
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d==c then d=Duel.GetAttacker() end
	if d and d:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsType(TYPE_EFFECT) and not c:IsStatus(STATUS_BATTLE_DESTROYED) then
		local e1=fuef.S(c,nil,EFFECT_DISABLE,nil,nil,nil,nil,nil,nil,d,RESET_EVENT+0x17a0000)
	end
end
--e3
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"D","IsTyp+AbleTo",{"RI+S","H"},nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=fugf.SelectFilter(tp,"D","IsTyp+AbleTo",{"RI+S","H"},nil,1)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end