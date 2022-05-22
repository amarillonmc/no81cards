--人理之诗 无铭胜利之剑
function c22021320.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22021320+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c22021320.cost)
	e1:SetTarget(c22021320.target)
	e1:SetOperation(c22021320.activate)
	c:RegisterEffect(e1)
end
c22021320.effect_with_altria=true
function c22021320.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c22021320.desfilter(c,tc,ec)
	return c:GetEquipTarget()~=tc and c~=ec
end
function c22021320.costfilter(c,ec,tp)
	if not c:IsSetCard(0xff9) then return false end
	return Duel.IsExistingTarget(c22021320.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c,c,ec)
end
function c22021320.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c22021320.costfilter,1,c,c,tp)
		else
			return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,c22021320.costfilter,1,1,c,c,tp)
		Duel.Release(sg,REASON_COST)
		Duel.SelectOption(tp,aux.Stringid(22021320,0))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1800)
end
function c22021320.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
	   Duel.BreakEffect()
	   Duel.SelectOption(tp,aux.Stringid(22021320,1))
	   Duel.SelectOption(tp,aux.Stringid(22021320,2))
	   Duel.Damage(1-tp,1800,REASON_EFFECT)
	end
end
