--邪骨团 十字
local m=64800139
local cm=_G["c"..m]
Duel.LoadScript("c64800135.lua")
function cm.initial_effect(c)
	local e0=Suyu_02_x.gi(c,m)
	local e1,e2=Suyu_02_x.geffect(c,m,cm.tg,cm.op,CATEGORY_TOHAND,EFFECT_FLAG_CARD_TARGET)
end
cm.setname="Zx02"
function cm.filter(c,e,tp)
	return c:IsType(TYPE_SPELL) and c:IsFaceup() and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc)
		g:AddCard(tc)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end