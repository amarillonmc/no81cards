--A jump to the sky turns to a rider kick
function c9981233.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9981233+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9981233.cost)
	e1:SetTarget(c9981233.target)
	e1:SetOperation(c9981233.activate)
	c:RegisterEffect(e1)
  --act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c9981233.handcon)
	c:RegisterEffect(e2)
end
function c9981233.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9981233.desfilter(c,tc,ec)
	return c:GetEquipTarget()~=tc and c~=ec
end
function c9981233.costfilter(c,ec,tp)
	if not c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbc9) then return false end
	return Duel.IsExistingTarget(c9981233.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c,c,ec)
end
function c9981233.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c9981233.costfilter,1,c,c,tp)
		else
			return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,c9981233.costfilter,1,1,c,c,tp)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c9981233.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981233,0))
end
function c9981233.hcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbc9) and c:IsLinkAbove(2)
end
function c9981233.handcon(e)
	return Duel.IsExistingMatchingCard(c9981233.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end