--我可去你妈的吧
function c9950276.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9950276.cost)
	e1:SetTarget(c9950276.target)
	e1:SetOperation(c9950276.activate)
	c:RegisterEffect(e1)
end
function c9950276.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9950276.desfilter(c,tc,ec)
	return c:GetEquipTarget()~=tc and c~=ec
end
function c9950276.costfilter(c,ec,tp)
	return c:IsType(TYPE_TUNER) and Duel.IsExistingTarget(c9950276.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c,ec)
end
function c9950276.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroupEx(tp,c9950276.costfilter,1,c,c,tp)
		else
			return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroupEx(tp,c9950276.costfilter,1,1,c,c,tp)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9950276.chlimit)
	end
end
function c9950276.chlimit(e,ep,tp)
	return tp==ep
end
function c9950276.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

