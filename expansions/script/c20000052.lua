--无亘龙 特里纳塔奇
if not pcall(function() require("expansions/script/c20000000") end) then require("script/c20000000") end
local cm,m,o=GetID()
fu_imm=fu_imm or {}
function fu_imm.give(c,e,cat,tg,op)
	local e1=fuef.FG(c,"GR","M",fu_imm.give_con1,fu_imm.give_tg1,c,nil,nil,e)
	local e2=fuef.STO(c,nil,cat,EVENT_BE_MATERIAL,"DE",c:GetCode(),fu_imm.give_con3,nil,tg,op,c)
	return e1,e2
end
function fu_imm.give_con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(20000052)>0
end
function fu_imm.give_tg1(e,c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsRace(RACE_DRAGON)
end
function fu_imm.give_con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if fucf.IsLoc(c,"GR") and r==REASON_RITUAL and c:GetReasonCard():IsRace(RACE_DRAGON) then
		c:RegisterFlagEffect(20000052,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(20000052,0))
		return true
	end
	return false
end
--------------------------------
if not cm then return false end
function cm.initial_effect(c)
	local e1=fuef.SC(c,nil,EVENT_BATTLE_DAMAGE,nil,"M",1,cm.con1,cm.op1)
	local e2={fu_imm.give(c,e1,"SH",cm.tg3,cm.op3)}
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
--e3
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"D","IsTyp+AbleTo",{"RI+M","H"},nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=fugf.SelectFilter(tp,"D","IsTyp+AbleTo",{"RI+M","H"},nil,1)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end