--俯瞰苍界之鸦
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000000") end) then require("script/c20000000") end
fu_kurusu = fu_kurusu or {}
local FK=fu_kurusu
function FK.A(c,code,cat,tg,op)
	aux.AddCodeList(c,20000001)
	local e1=fucg.ef.A(c,0,cat,nil,"TG","O",FK.A_con1,nil,tg,op,c)
	local e2=fucg.ef.A(c,"TH","SH",EVENT_CHAINING,nil,"O",FK.A_con2,nil,FK.A_tg2,FK.A_op2,c)
	return e1,e2
end
function FK.RH(e,tp,eg,ep,ev,re,r,rp)
	local res={RESET_PHASE+PHASE_STANDBY,Duel.GetCurrentPhase()<=PHASE_STANDBY and 2 or 1}
	fucg.ef.FC(e,nil,EVENT_PHASE+PHASE_STANDBY,nil,nil,1,FK.RH_con,FK.RH_op,tp,res,Duel.GetTurnCount())
end
function FK.A_con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0):Filter(Card.IsFaceup,nil):FilterCount(Card.IsCode,nil,20000001)>0
end
function FK.A_con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function FK.A_tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(Card.IsAbleToHand,nil):IsExists(Card.IsCode,1,nil,20000001) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function FK.A_op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(Card.IsAbleToHand,nil):Filter(Card.IsCode,nil,20000001):Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function FK.RH_conf(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function FK.RH_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(FK.RH_conf,tp,LOCATION_GRAVE,0,1,nil)
end
function FK.RH_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(FK.RH_conf),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end
if not cm then return end
--------------------------------------------------------
function cm.initial_effect(c)
	local e1,e2=FK.A(c,m,CATEGORY_TOGRAVE,cm.tg,cm.op)
end
--e1
function cm.tgf1(c,tc)
	if not (c:IsType(TYPE_SPELL) and c:IsAbleToGrave()) or c:IsCode(tc:GetCode()) then return end
	c=c:GetActivateEffect(true,true,false)
	return c and c:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function cm.tgf(c)
	return c:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_DECK,0,1,nil,c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and cm.tgf(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tgf,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(cm.tgf1,tp,LOCATION_DECK,0,nil,tc)
	if tc and tc:IsRelateToEffect(e) and #g>0 then
		g=g:Select(tp,1,1,nil):GetFirst()
		if not (g and Duel.SendtoGrave(g,REASON_EFFECT)>0) then return end
		FK.RH(e,tp,eg,ep,ev,re,r,rp)
	end
end