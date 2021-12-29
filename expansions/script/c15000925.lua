local m=15000925
local cm=_G["c"..m]
cm.name="死蔷薇的证人-『兽角』"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000936)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.splimcon)
	e1:SetTarget(cm.splimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e2)
	cm.deadrose_effect_onfield_splimit=e1
	cm.deadrose_effect_onfield_slimit=e2
	--to hand 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCountLimit(1)  
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3)
	--xyz!
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,15000925)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
	cm.deadrose_effect_three=e4
end
function cm.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function cm.splimit(e,c)
	return c:IsSetCard(0x3f3f)
end
function cm.th2filter(c)
	return c:IsSetCard(0x3f3f) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandler():GetControler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.th2filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.th2filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.th2filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PLANT) and c:IsAbleToGrave()
end
function cm.tg3filter(c)
	return c:IsCode(15000936) and c:IsAbleToGrave()
end
function cm.fselect(g)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	return tc1:GetLevel()+tc2:GetLevel()==8
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tg3filter,tp,LOCATION_EXTRA,0,1,nil) and g:CheckSubGroup(cm.fselect,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:SelectSubGroup(tp,cm.fselect,false,2,2)
	if g1 and g1:GetCount()==2 and Duel.SendtoGrave(g1,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g3=Duel.SelectMatchingCard(tp,cm.tg3filter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g3:GetCount()~=0 then
			Duel.SendtoGrave(g3,REASON_EFFECT)
		end
	end
end