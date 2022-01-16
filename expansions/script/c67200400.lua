--术结天缘 安贝尔·洛奇
function c67200400.initial_effect(c)
	--Pendulum Summon
	c:EnableCounterPermit(0x1,LOCATION_PZONE)
	c:SetCounterLimit(0x1,6)
	aux.EnablePendulumAttribute(c)
	--Add Counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(c67200400.counterop)
	c:RegisterEffect(e2)  
	--pendulum scale down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(c67200400.scaledown)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e4)
	--draw & draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67200400,0))
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCost(c67200400.drcost)
	e5:SetTarget(c67200400.drtg)
	e5:SetOperation(c67200400.drop)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(67200400,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_HAND)
	e6:SetCountLimit(1,67200400)
	e6:SetCondition(c67200400.spcon)
	e6:SetTarget(c67200400.sptg)
	e6:SetOperation(c67200400.spop)
	c:RegisterEffect(e6)
end
function c67200400.counterop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,2)
	end
end
--
function c67200400.scaledown(e,c)
	return -c:GetCounter(0x1)
end
--
function c67200400.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,6,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1,6,REASON_COST)
end
function c67200400.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c67200400.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,dc)
	if dc:IsSetCard(0x5671) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
end
--
function c67200400.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0x5671)
		and c:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA) and c:IsPreviousControler(tp)
end
function c67200400.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200400.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end


