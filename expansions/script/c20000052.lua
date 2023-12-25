--无亘龙 特里纳塔奇
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
fu_imm = fu_imm or {}
function fu_imm.initial(cm,cat,typ,...)
	cm.initial_effect = fu_imm.give(cm,cat,typ,...)
	return cm
end
function fu_imm.give(cm,cat,typ,...)
	local list = {...}
	return function(c)
		cm.lib = fu_imm
		local E = fuef[typ](c,nil,table.unpack(list))
		fuef.FG(c,c,"GR,M+0,give_con1,give_tg1,,",E.e)
		fuef.STO(c,c,"BM,",cat,"DE",c:GetCode(),"give_con2,,tg2,op2")
	end
end
fu_imm.give_con1 = function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():GetFlagEffect(20000052)>0 end
fu_imm.give_tg1 = function(e,c) return fucf.Filter(c,"IsTyp+IsRac","RI+M,DR") end
function fu_imm.give_con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if fucf.IsLoc(c,"GR") and r==REASON_RITUAL and fucf.IsRac(c:GetReasonCard(),"DR") then
		c:RegisterFlagEffect(20000052,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(20000052,0))
		return true
	end
	return false
end
--------------------------------
if not self_table then return false end
local cm = fu_imm.initial(self_table,"SH","SC",EVENT_BATTLE_DAMAGE,",,M,1,con1,op1")
--e1
cm.con1 = function(e,tp,eg,ep,ev,re,r,rp) return ep~=tp end
cm.op1 = function(e,tp,eg,ep,ev,re,r,rp) Duel.Draw(tp,1,REASON_EFFECT) end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"D","IsTyp+AbleTo","RI+M,H",1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=fugf.SelectFilter(tp,"D","IsTyp+AbleTo","RI+M,H")
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end