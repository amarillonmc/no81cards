--教导唱诗班 浮尔
function c11634014.initial_effect(c)
	--to grave and hand
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11634014) 
	e1:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0x145) end,tp,LOCATION_MZONE,0,1,nil) end)
	e1:SetCost(c11634014.tghcost)
	e1:SetTarget(c11634014.tghtg)
	e1:SetOperation(c11634014.tghop)
	c:RegisterEffect(e1) 
	--tohand and ex 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21634014) 
	e2:SetCondition(c11634014.tehcon)
	e2:SetCost(c11634014.tehcost)
	e2:SetTarget(c11634014.tehtg)
	e2:SetOperation(c11634014.tehop)
	c:RegisterEffect(e2) 
end 
function c11634014.tghcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c11634014.tghfilter(c)
	return c:IsSetCard(0x145) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11634014.tghtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil) and Duel.IsExistingMatchingCard(c11634014.tghfilter,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11634014.tghop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst() 
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then 
		if not Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,0,LOCATION_MZONE,1,nil,LOCATION_EXTRA) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_CANNOT_TRIGGER) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)
		end 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c11634014.tghfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)
	return c:IsLocation(LOCATION_EXTRA) end) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x145) and sumtype&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM end) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
end
function c11634014.tehckfil(c,tp) 
	local rc=nil
	if not (c:IsSetCard(0x145) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)) then return false end
	if c:IsReason(REASON_BATTLE) then
		rc=c:GetReasonCard()
	elseif c:IsReason(REASON_EFFECT) then
		rc=c:GetReasonEffect():GetHandler()
	end
	if not (rc and rc:IsSummonLocation(LOCATION_EXTRA)) then return false end
	if c:IsReason(REASON_BATTLE) then
		local bc=Duel.GetAttacker()
		return bc and bc==rc
	elseif c:IsReason(REASON_EFFECT) then
		return true
	end
end
function c11634014.tehcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11634014.tehckfil,1,nil,tp) 
end
function c11634014.tehcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end 
function c11634014.tehtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and c:IsSetCard(0x145) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToExtra() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c11634014.tehop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToHand() and c:IsSetCard(0x145) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then 
		Duel.ConfirmCards(1-tp,tc) 
		local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToExtra() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) end,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil) 
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
	end 
end 






