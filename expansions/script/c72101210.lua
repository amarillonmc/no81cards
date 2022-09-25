--深空 神之怒火
function c72101210.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72101210+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)

	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72101210,0))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,72101211)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCondition(c72101210.tzcon)
	e2:SetTarget(c72101210.tztg)
	e2:SetOperation(c72101210.tzop)
	c:RegisterEffect(e2)
	
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c72101210.immtg)
	e3:SetValue(c72101210.efilter)
	c:RegisterEffect(e3)

	 --shen weifengkangxing
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(1)
	e4:SetCondition(c72101210.godcon)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)

	--fang zhishiwu tongzhao
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(c72101210.zswop)
	c:RegisterEffect(e6)
	--fang zhishiwu tezhao
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)

end

--summon
function c72101210.tzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c72101210.tzfilter(c,e,tp)
	return c:IsSetCard(0xcea) and c:IsLevel(10) and c:IsSummonable(true,nil) 
end
function c72101210.tztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72101210.tzfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c72101210.tzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c72101210.tzfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
	end
end

--immune
function c72101210.immtg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:GetOriginalAttribute()==ATTRIBUTE_DIVINE) and c:IsSetCard(0xcea)
end
function c72101210.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end

--shen weifengkangxing
function c72101210.sfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0xcea) and c:IsAttribute(ATTRIBUTE_DIVINE)
end
function c72101210.godcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72101210.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

--fang zhishiwu
function c72101210.zswfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:GetOriginalAttribute()==ATTRIBUTE_DIVINE) and c:IsSetCard(0xcea)
end
function c72101210.cwfilter(c)
	return c:IsAbleToRemove()
end
function c72101210.zswop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c72101210.zswfilter,nil)
	if ct>0 then

		e:GetHandler():AddCounter(0x7210,ct,true)
		if e:GetHandler():AddCounter(0x7210,ct,true) 
			and Duel.IsCanRemoveCounter(tp,1,1,0x7210,1,REASON_EFFECT)
			and Duel.IsExistingTarget(c72101210.cwfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
			and Duel.SelectYesNo(tp,aux.Stringid(72101210,1)) then

			Duel.RemoveCounter(tp,1,1,0x7210,1,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if g:GetCount()>0 then

				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg=g:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end


