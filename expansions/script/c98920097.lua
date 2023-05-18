--黯黑之龙 梅菲斯特尔
function c98920097.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920097,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920097)
	e1:SetCondition(c98920097.spcon)
	e1:SetTarget(c98920097.sptg)
	e1:SetOperation(c98920097.spop)
	c:RegisterEffect(e1)
	 --handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920097,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930097)
	e3:SetCost(c98920097.thcost)
	e3:SetCondition(c98920097.hdcon)
	e3:SetTarget(c98920097.hdtg)
	e3:SetOperation(c98920097.hdop)
	c:RegisterEffect(e3)
end
function c98920097.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,e:GetHandler(),ATTRIBUTE_DARK) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,e:GetHandler(),ATTRIBUTE_DARK)
	Duel.Release(g,REASON_COST)
end
function c98920097.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c98920097.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g>0 and #g==Duel.GetMatchingGroupCount(c98920097.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98920097.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920097.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920097.cfilter1(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c98920097.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c98920097.cfilter1,1,nil,1-tp)
end	
function c98920097.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c98920097.hdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c98920097.cfilter1,nil,e,1-tp)
	local dg=eg:GetFirst()
	Duel.ConfirmCards(tp,dg)
	local opt=0
	if not e:GetHandler():IsLocation(LOCATION_MZONE) then
		 opt=Duel.SelectOption(tp,aux.Stringid(98920097,0))
	else
		 opt=Duel.SelectOption(tp,aux.Stringid(98920097,0),aux.Stringid(98920097,1))
	end
	if opt==0 then 
		if Duel.SelectOption(tp,aux.Stringid(18138630,3),aux.Stringid(18138630,4))==0 then
		   Duel.SendtoDeck(dg,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
		   Duel.SendtoDeck(dg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	else
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		Duel.SendtoHand(dg,tp,REASON_EFFECT)
	end
end