--端午节的觉醒三尾狐
function c8709013.initial_effect(c)
	  --xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c8709013.mfilter,c8709013.xyzcheck,2,2)
	 --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c8709013.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c8709013.defval)
	c:RegisterEffect(e2)  
		--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8709013,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,8709013)
	e3:SetCost(c8709013.thcost)
	e3:SetTarget(c8709013.target)
	e3:SetOperation(c8709013.activate)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(8709013,1))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,8809013)
	e4:SetCost(c8709013.thcost1)
	e4:SetTarget(c8709013.atktg)
	e4:SetOperation(c8709013.atkop)
	c:RegisterEffect(e4)



end
function c8709013.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function c8709013.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c8709013.atkfilter(c)
	return c:IsSetCard(0xafa) and c:GetAttack()>=0
end
function c8709013.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709013.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c8709013.deffilter(c)
	return c:IsSetCard(0xafa) and c:GetDefense()>=0
end
function c8709013.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709013.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c8709013.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c8709013.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xafa) and c:GetSequence()<5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8709013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and c8709013.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c8709013.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c8709013.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c8709013.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c8709013.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c8709013.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xafa)
end
function c8709013.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8709013.atkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c8709013.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c8709013.atkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if ct>0 then
		local tc=g:GetFirst()
		while tc do
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-300*ct)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end





