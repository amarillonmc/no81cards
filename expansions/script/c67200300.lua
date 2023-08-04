--结天缘的封缄英杰 菲娅
function c67200300.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200300,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200300)
	e1:SetCost(c67200300.spcon)
	e1:SetTarget(c67200300.sptg)
	e1:SetOperation(c67200300.spop)
	c:RegisterEffect(e1)
	--Release monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200300,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(2,67200301)
	e2:SetCondition(c67200300.ctcon)
	e2:SetCost(c67200300.ctcost)
	e2:SetTarget(c67200300.cttg)
	e2:SetOperation(c67200300.ctop)
	c:RegisterEffect(e2)	
end
function c67200300.spfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and (c:IsSetCard(0x3674) or c:IsSetCard(0x671))
end
function c67200300.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg:IsExists(c67200300.spfilter,1,nil,tp)
end
function c67200300.penfilter(c)
	return (c:IsSetCard(0x3674) or c:IsSetCard(0x671)) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67200300.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)and Duel.IsExistingMatchingCard(c67200300.penfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200300.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.IsExistingMatchingCard(c67200300.penfilter,tp,LOCATION_DECK,0,1,nil) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c67200300.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
--
function c67200300.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) 
end
function c67200300.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c67200300.filter(c,tp)
	return c:IsFaceup() and c:IsControlerCanBeChanged(true)
end
function c67200300.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c67200300.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c67200300.filter,tp,0,LOCATION_MZONE,1,nil,tp)
		and Duel.GetMZoneCount(tp,e:GetHandler(),tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c67200300.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c67200300.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
--
