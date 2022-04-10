--珊海环的封缄英杰 索尼娅
function c67200302.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon and to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200302,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200302)
	e1:SetCondition(c67200302.spcon)
	e1:SetTarget(c67200302.sptg)
	e1:SetOperation(c67200302.spop)
	c:RegisterEffect(e1)
	--Release monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200302,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c67200302.ctcon)
	e2:SetCost(c67200302.ctcost)
	e2:SetTarget(c67200302.cttg)
	e2:SetOperation(c67200302.ctop)
	c:RegisterEffect(e2)  
end

--
function c67200302.spfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and (c:IsSetCard(0x675) or c:IsSetCard(0x3674)) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c67200302.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200302.spfilter,1,nil,tp)
end
function c67200302.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200302.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.SendtoDeck(eg,nil,REASON_EFFECT)
	end
end
--
function c67200302.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c67200302.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c67200302.filter(c,tp)
	return c:IsFaceup()
end
function c67200302.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c67200302.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c67200302.filter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c67200302.filter,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c67200302.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end