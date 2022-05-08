--寒霜灵兽 冰精灵
function c33200903.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,33200903)
	e1:SetCost(c33200903.spcost)
	e1:SetTarget(c33200903.sptg)
	e1:SetOperation(c33200903.spop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200903,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,33210903)
	e2:SetTarget(c33200903.cttg)
	e2:SetOperation(c33200903.ctop)
	c:RegisterEffect(e2) 
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33200903.indcon)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end

--e1
function c33200903.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST)
end
function c33200903.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c33200903.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e2
function c33200903.ctfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_MONSTER) or (c:IsSetCard(0x332a) and c:IsLocation(LOCATION_PZONE)))
end
function c33200903.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_PZONE) and c33200903.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200903.ctfilter,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE+LOCATION_PZONE,1,nil) and (e:GetHandler():IsLocation(LOCATION_MZONE) or (e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsAbleToExtra())) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c33200903.ctfilter,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE+LOCATION_PZONE,1,1,nil)
	local tc=g:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,tc,nil,0,0x132a)
	if e:GetHandler():IsLocation(LOCATION_HAND) then 
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),nil,0,LOCATION_HAND)
	elseif e:GetHandler():IsLocation(LOCATION_MZONE) then 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),nil,0,LOCATION_MZONE)
	end
end
function c33200903.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ctc=0
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if tc:IsType(TYPE_LINK) then 
			ctc=tc:GetLink()
		elseif tc:IsType(TYPE_XYZ) then 
			ctc=tc:GetRank()
		else
			ctc=tc:GetLevel()
		end
		if ctc>0 then
			tc:AddCounter(0x132a,ctc)
			Duel.BreakEffect()
			if e:GetHandler():IsLocation(LOCATION_ONFIELD) then
				Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
			elseif e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsAbleToExtra() then 
				Duel.SendtoExtraP(e:GetHandler(),tp,REASON_EFFECT)
			end
		end
	end
end

--e4
function c33200903.indcon(e)
	return Duel.GetFlagEffect(tp,33200900)>0
end