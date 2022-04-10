--终末旅者装备 连发霰弹枪
function c64831017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,64831017+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c64831017.cost)
	e1:SetTarget(c64831017.target)
	e1:SetOperation(c64831017.activate)
	c:RegisterEffect(e1)
end
function c64831017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c64831017.desfilter(c,tc,ec)
	return c:GetEquipTarget()~=tc and c~=ec
end
function c64831017.costfilter(c,ec)
	if not c:IsRace(RACE_WARRIOR) then return false end
	return Duel.IsExistingTarget(c64831017.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c,ec)
end
function c64831017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c64831017.costfilter,1,c,c)
		else
			return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,c64831017.costfilter,1,1,c,c)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c64831017.tgfil(c)
	return c:IsSetCard(0x5410) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c64831017.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(sg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c64831017.tgfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(64831017,0)) then
		local gg=Duel.SelectMatchingCard(tp,c64831017.tgfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(gg,REASON_EFFECT)
	end
end