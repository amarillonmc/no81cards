--无亘龙 杜米利奥尼
if not pcall(function() require("expansions/script/c20000052") end) then require("script/c20000052") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=fuef.FC(c,nil,EVENT_CHAIN_SOLVED,nil,"M",nil,cm.con1,cm.op1)
	local e2={fu_imm.give(c,e1,"SH",cm.tg3,cm.op3)}
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler()==e:GetHandler()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=fugf.GetFilter(tp,"M","IsTyp+IsRace+IsFaceup",{"RI+M",RACE_DRAGON})
	for c in aux.Next(g) do
		local atk=c:GetBaseAttack()+250
		local e1=fuef.S(e,nil,EFFECT_SET_BASE_ATTACK,nil,"M",atk,nil,nil,nil,c,RESET_EVENT+RESETS_STANDARD)
	end
end
--e3
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler():GetReasonCard()
	if chk==0 then return fugf.Filter(c:GetMaterial(),"Compare",{"GetRitualLevel",1,"A",c},nil,1) and fugf.GetFilter(tp,"D","IsSetCard+AbleTo",{0xafd1,"H"},nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetReasonCard()
	local g=fugf.Filter(c:GetMaterial(),"Compare",{"GetRitualLevel",1,"A",c})
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	g=fugf.SelectFilter(tp,"D","IsSetCard+AbleTo",{0xafd1,"H"},nil,1,#g)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end