--末氏空骨 赤核
function c33330504.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33330504.descost)
	e1:SetTarget(c33330504.destg)
	e1:SetOperation(c33330504.desop)
	c:RegisterEffect(e1)
	--overskeleton!!!
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33330504)
	e2:SetCondition(c33330504.skcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c33330504.sktg)
	e2:SetOperation(c33330504.skop)
	c:RegisterEffect(e2)
end
function c33330504.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c33330504.desfilter(c,e,tp)
	return c:IsDestructable(e) and Duel.IsExistingMatchingCard(c33330504.resfilter,tp,LOCATION_ONFIELD,0,1,c)
end
function c33330504.resfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5552) and c:IsAbleToRemove()
end
function c33330504.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c33330504.desfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33330504.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33330504.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
end
function c33330504.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c33330504.resfilter,tp,LOCATION_ONFIELD,0,1,1,tc)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c33330504.skconfil(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c33330504.skcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c33330504.skconfil,tp,LOCATION_MZONE,0,1,nil)
end
function c33330504.skfil(c,e,tp)
	return c:IsSetCard(0x5552) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33330504.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33330504.skfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c33330504.skop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33330504.skfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
