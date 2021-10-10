--AK-行医者桑葚
function c82568089.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c82568089.mfilter,c82568089.xyzcheck,2,2)
	c:EnableReviveLimit()
	--Recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c82568089.retg)
	e1:SetOperation(c82568089.reop)
	c:RegisterEffect(e1)
	--avoid damage
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CHANGE_DAMAGE)
	e11:SetRange(LOCATION_PZONE)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetTargetRange(1,0)
	e11:SetValue(0)
	c:RegisterEffect(e11)
	--spsummon&P Set
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,82568089)
	e4:SetCost(c82568089.cost)
	e4:SetTarget(c82568089.target)
	e4:SetOperation(c82568089.operation)
	c:RegisterEffect(e4)
end
c82568089.pendulum_level=2
function c82568089.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x825) and c:IsLevelAbove(1)
end
function c82568089.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c82568089.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c82568089.spfilter(c,e,tp)
	return c:IsSetCard(0x825) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c82568089.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568089.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and 
			 (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c82568089.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568089.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	end
end
function c82568089.refilter(c)
	return c:IsFaceup() and c:IsSetCard(0x825)
end
function c82568089.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsSetCard(0x825) end
	if chk==0 then return Duel.IsExistingTarget(c82568089.refilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82568089.refilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local red=0
	if tc:IsType(TYPE_XYZ) 
	then  red=tc:GetRank()*200 
	else if tc:IsType(TYPE_LINK)
	then  red=tc:GetLink()*200
	else  red=tc:GetLevel()*200
	end
	end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,red)
end
function c82568089.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT) and tc:IsRelateToEffect(e) then
	local red=0
	if tc:IsType(TYPE_XYZ) 
	then  red=tc:GetRank()*200 
	else if tc:IsType(TYPE_LINK)
	then  red=tc:GetLink()*200
	else  red=tc:GetLevel()*200
	end
	end
	if red>0 then
	Duel.Recover(tp,red,REASON_EFFECT)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c82568089.efilter)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e5)
	end
	end
end
function c82568089.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner() and  te:IsActiveType(TYPE_MONSTER)
end
