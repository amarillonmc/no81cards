--妖精传姬-塞壬
function c98920687.initial_effect(c)
	--c:SetSPSummonOnce(98920687)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),2,2)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c98920687.spcon)
	e4:SetTarget(c98920687.sptg)
	e4:SetOperation(c98920687.spop)
	c:RegisterEffect(e4)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c98920687.imcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_MZONE))
	e3:SetValue(c98920687.efilter)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920687,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c98920687.drcon)
	e4:SetTarget(c98920687.drtg)
	e4:SetOperation(c98920687.drop)
	c:RegisterEffect(e4)
end
function c98920687.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c98920687.imcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==2
end
function c98920687.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c98920687.thfilter(c)
	return c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c98920687.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920687.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920687.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920687.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920687.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c98920687.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920687.cfilter,1,nil,tp) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) and eg:GetCount()==1
end
function c98920687.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and eg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920687.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false)  then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)~=0 then	 
	   local e3=Effect.CreateEffect(c)
	   e3:SetType(EFFECT_TYPE_SINGLE)
	   e3:SetCode(EFFECT_DISABLE)
	   e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	   c:RegisterEffect(e3)
	   local e4=e3:Clone()
	   e4:SetCode(EFFECT_DISABLE_EFFECT)
	   e4:SetValue(RESET_TURN_SET)
	   c:RegisterEffect(e4)
	   local e5=e3:Clone()
	   e5:SetCode(EFFECT_CANNOT_ATTACK)
	   c:RegisterEffect(e5)
	   Duel.SpecialSummonComplete()
	   end
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	   e1:SetValue(LOCATION_REMOVED)
	   c:RegisterEffect(e1,true)
	end
end
function c98920687.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end