--『蛮勇』的陆
local m=33709013
local cm=_G["c"..m]
Duel.LoadScript("c16199990.lua")
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--
	local es=Effect.CreateEffect(c)
	es:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	es:SetCode(EVENT_REMOVE)
	es:SetRange(LOCATION_GRAVE)
	es:SetCondition(cm.kemuricon)
	es:SetOperation(cm.kemuriop)
	c:RegisterEffect(es)
	if not aux.kemuricheck then
		aux.kemuricheck=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
		e1:SetTarget(cm.tg)
		e1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.tg(e,c)
	local code=c:GetOriginalCode()
	return code>=33709010 and code<=33709015 and (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or not (c:IsDisabled() and c:IsLocation(LOCATION_ONFIELD)))
end
function cm.check(c)
	local code=c:GetOriginalCode()
	return code>=m and code<=33709016 and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.check2(c)
	local code=c:GetOriginalCode()
	return code>=m and code<=33709016 and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.kemuricon(e,tp,eg)
	return eg:IsExists(cm.check,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.kemuriop(e,tp,eg)
	local sg=eg:Filter(cm.check2,nil)
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) and sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
	end
end
function cm.check3(c)
	local code=c:GetOriginalCode()
	return code>=33709004 and code<=33709009 and c:IsDiscardable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then Duel.IsExistingMatchingCard(cm.check3,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.check3,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end