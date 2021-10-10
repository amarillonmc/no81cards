--钢战-勇壮
function c82557949.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c82557949.condition)
	e1:SetTarget(c82557949.target)
	e1:SetOperation(c82557949.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c82557949.mttg)
	e2:SetOperation(c82557949.mtop)
	c:RegisterEffect(e2)
end
function c82557949.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc,level=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_LEVEL)
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and (rc:GetLevel()>=8 or rc:GetRank()>=5 or rc:GetLink()>=4) and loc==LOCATION_MZONE
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c82557949.filter1(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,3,REASON_EFFECT)
end
function c82557949.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c82557949.filter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c82557949.filter1,tp,LOCATION_MZONE,0,1,nil,tp) 
						  and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c82557949.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82557949.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if  Duel.NegateActivation(ev) and tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	if not tc:CheckRemoveOverlayCard(tp,3,REASON_EFFECT) then return end
	if tc:RemoveOverlayCard(tp,tc:GetOverlayCount(),tc:GetOverlayCount(),REASON_EFFECT)~=0 then
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	end
end
function c82557949.filter12(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x829)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c82557949.filter2),tp,LOCATION_GRAVE,0,1,c)
end
function c82557949.filter2(c,e)
	return c:IsType(TYPE_MONSTER) 
end
function c82557949.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c82557949.filter12(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c82557949.filter12,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c82557949.filter12,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c82557949.mtop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82557949.filter2),tp,LOCATION_GRAVE,0,1,1,tc,e)
	if g:GetCount()>0 then
		local og=g:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,g)
	end
end