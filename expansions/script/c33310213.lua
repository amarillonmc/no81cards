--空想祈羽 虚龙
function c33310213.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	 aux.AddFusionProcFunRep(c,c33310213.fusfil,2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD,0,aux.tdcfop(c))
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33310213,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33310213.cost)
	e1:SetTarget(c33310213.target)
	e1:SetOperation(c33310213.activate)
	c:RegisterEffect(e1)
	--forbidden
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_FORBIDDEN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetTarget(c33310213.bantg)
	c:RegisterEffect(e2)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e6) 
	local e7=e2:Clone()
	e7:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e7) 
	local e8=e2:Clone()
	e8:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e8) 
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33310213,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c33310213.spcon)
	e5:SetTarget(c33310213.sptg)
	e5:SetOperation(c33310213.spop)
	c:RegisterEffect(e5)
end
function c33310213.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) 
end
function c33310213.spfilter(c,e,tp)
	return c:IsSetCard(0x551) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c33310213.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310213.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c33310213.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33310213.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c33310213.bantg(e,c)
	return c:IsPublic()
end
function c33310213.fusfil(c)
	return c:IsFusionType(TYPE_FUSION) and c:IsFusionSetCard(0x551)
end
function c33310213.costfil(c)
	return c:IsAbleToHandAsCost()
end
function c33310213.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c33310213.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		 if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c33310213.costfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.SelectMatchingCard(tp,c33310213.costfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
	Duel.SetTargetCard(g)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c33310213.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	end
end