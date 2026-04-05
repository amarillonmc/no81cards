--片桐警官逃逸机
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_REMOVED+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.prop2)
	c:RegisterEffect(e2)
	
end

function s.tgfilter1(c,e,tp)
	return c:IsAbleToRemove() and (c:IsSetCard(0x606) and c:IsType(TYPE_EQUIP))
end
function s.spfilter1(c,e,tp,mc)
	return c:IsCode(21000763) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a = false
	local ct=Duel.GetCurrentChain()
	if ct>=2 then 
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		a = tep==1-tp and e:IsHasType(EFFECT_TYPE_ACTIVATE)
	end
	
	local b = a and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,e:GetHandler(),id) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	if b then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	end
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	local g00 = Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,e:GetHandler(),id)
	Duel.ConfirmCards(1-tp,g00)
	Duel.BreakEffect()
	local ct=Duel.GetCurrentChain()
	local a = false
	if ct>=2 then 
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		a = tep==1-tp and e:IsHasType(EFFECT_TYPE_ACTIVATE)
	end
	
	local b = a and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	local a1 = Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	
	if not (a1 or b) or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	
	if not Duel.SelectYesNo(tp,aux.Stringid(id,4)) then return end
	
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g2 = Group.CreateGroup()
	if b and (not a1 or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
		g2 = Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,e:GetHandler(),e,tp)
	else
		g2 = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler(),e,tp)
	end
	
	if g2:GetCount()>0 then
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
		if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.tgfilter1),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp) then return end
		local g1 = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tgfilter1),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
		if g1:GetCount()>0 then
			Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		end
	end
end

function s.thcfilter(c,tp)
	return c:IsCode(21000763) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_RULE)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.thcfilter,1,nil,tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end