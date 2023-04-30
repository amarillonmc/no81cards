--无亘龙 赞米利亚登
if not pcall(function() require("expansions/script/c20000052") end) then require("script/c20000052") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=fuef.F(c,nil,EFFECT_CHANGE_DAMAGE,"PTG","M","+1",cm.val1)
	local e2={fu_imm.give(c,e1,"TH",cm.tg3,cm.op3)}
	if not cm.glo then
		cm.glo={0,0}
		local e4=fuef.FC(c,nil,EVENT_PHASE_START+PHASE_DRAW,nil,nil,nil,nil,cm.op4,0)
		local e5=fuef.FC(c,nil,EVENT_BATTLE_DAMAGE,nil,nil,nil,nil,cm.op5,0)
	end
end
--e1
function cm.val1(e,re,dam,r,rp,rc)
	return r==REASON_BATTLE and cm.glo[2-rp]>dam and cm.glo[2-rp] or dam
end
--e3
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler():GetReasonCard()
	if chk==0 then return fugf.Filter(c:GetMaterial(),"Compare",{"GetRitualLevel",1,"A",c},nil,1) 
		and fugf.GetFilter(tp,"GR","IsSetCard+AbleTo+IsFaceup",{0xafd1,"H"},nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetReasonCard()
	local g=fugf.Filter(c:GetMaterial(),"Compare",{"GetRitualLevel",1,"A",c})
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	g=fugf.SelectFilter(tp,"GR",{"IsSetCard+AbleTo",aux.NecroValleyFilter(Card.IsFaceup)},{0xafd1,"H"},nil,1,#g)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
--e4
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	cm.glo={0,0}
end
--e5
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	cm.glo[ep+1]=ev>cm.glo[ep+1] and ev or cm.glo[ep+1]
end