--束缚的首饰●神
function c75075611.initial_effect(c)
	c:EnableCounterPermit(0x757)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c75075611.damtg)
	e1:SetOperation(c75075611.damop)
	c:RegisterEffect(e1)	
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75075611,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+75075611)
	e1:SetRange(LOCATION_SZONE)
	--e1:SetCountLimit(1,75075611)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c75075611.tdtg)
	e1:SetOperation(c75075611.tdop)
	c:RegisterEffect(e1)
	aux.RegisterMergedDelayedEvent(c,75075611,EVENT_SUMMON_SUCCESS)
	aux.RegisterMergedDelayedEvent(c,75075611,EVENT_FLIP_SUMMON_SUCCESS)
	aux.RegisterMergedDelayedEvent(c,75075611,EVENT_SUMMON_SUCCESS)
end
function c75075611.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x75a)
end
function c75075611.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75075611.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroupCount(c75075611.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,g,0,0x757)
end
function c75075611.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroupCount(c75075611.filter,tp,LOCATION_MZONE,0,nil)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x757,g)
	end
end
--
function c75075611.cfilter(c,e)
	return c:IsFaceup() and c:IsCanChangePosition() and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_MZONE)
end
function c75075611.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) end
	if chk==0 then return eg:IsExists(c75075611.cfilter,1,nil,e)
		and c:IsCanRemoveCounter(tp,0x757,2,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=eg:FilterSelect(tp,c75075611.cfilter,1,1,nil,e)
	Duel.SetTargetCard(g)
end
function c75075611.filter1(c)
	return c:IsFaceup() and c:IsCanTurnSet() 
end
function c75075611.filter2(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function c75075611.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsSetCard(0x757) and Duel.IsExistingMatchingCard(c75075611.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:IsCanRemoveCounter(tp,0x757,2,REASON_EFFECT) then
			c:RemoveCounter(tp,0x757,2,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g=Duel.SelectMatchingCard(tp,c75075611.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)  
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
		if not tc:IsSetCard(0x757) and Duel.IsExistingMatchingCard(c75075611.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:IsCanRemoveCounter(tp,0x757,1,REASON_EFFECT) then
			c:RemoveCounter(tp,0x757,2,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g=Duel.SelectMatchingCard(tp,c75075611.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)  
			Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		end
	end
end