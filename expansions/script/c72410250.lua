--天穹司书 传光之斯缇妮
function c72410250.initial_effect(c)
	aux.AddCodeList(c,56433456)
	--to spell
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72410250,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,72410250)
	e1:SetTarget(c72410250.igtg)
	e1:SetOperation(c72410250.igop)
	c:RegisterEffect(e1)
	--ss success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72410250,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,72410251)
	e2:SetCondition(c72410250.retcon)
	e2:SetTarget(c72410250.rettg)
	e2:SetOperation(c72410250.retop)
	c:RegisterEffect(e2)
	--as spell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72410250,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,72410252)
	e3:SetCondition(c72410250.spellcon)
	e3:SetCost(c72410250.spellcost)
	e3:SetTarget(c72410250.spelltg)
	e3:SetOperation(c72410250.spellop)
	c:RegisterEffect(e3)
end
--
function c72410250.igtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_HAND))
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c72410250.igop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_HAND)) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(72410250,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
end
--
function c72410250.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsType(TYPE_SPELL) and rc:IsType(TYPE_CONTINUOUS)
end
function c72410250.filter(c)
	local thchk=Duel.IsEnvironment(56433456)
	return c:IsSetCard(0xa729) and c:IsType(TYPE_MONSTER) and (c:IsAbleToGrave() or (thchk and c:IsAbleToHand()))
end
function c72410250.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local thchk=Duel.IsEnvironment(56433456)
	if chk==0 then return Duel.IsExistingMatchingCard(c72410250.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,nil,nil,1,tp,LOCATION_DECK)
end
function c72410250.retop(e,tp,eg,ep,ev,re,r,rp)
	local thchk=Duel.IsEnvironment(56433456)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c72410250.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if thchk and g:GetFirst():IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(72410250,2)) then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		else
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
--
function c72410250.filter1(c,e,tp)
	return c:IsSetCard(0xa729) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c72410250.spellcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SPELL) and e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function c72410250.spellcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c72410250.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c72410250.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c72410250.spellop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72410250.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
