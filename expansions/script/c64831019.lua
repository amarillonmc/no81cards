--终末旅者 杰森
function c64831019.initial_effect(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,64831019)
	e1:SetCondition(c64831019.jumpcon)
	e1:SetCost(c64831019.jumpcost)
	e1:SetTarget(c64831019.jumptg)
	e1:SetOperation(c64831019.jumpop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(64831019,ACTIVITY_SPSUMMON,c64831019.counterfilter)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c64831019.regop)
	c:RegisterEffect(e2)
end
function c64831019.overfil(c)
	return c:IsSetCard(0x5410)
end
function c64831019.counterfilter(c)
	return c:IsType(TYPE_SYNCHRO) or c:GetSummonLocation()~=LOCATION_EXTRA 
end
function c64831019.jumpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(64831019,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c64831019.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c64831019.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c64831019.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO) and c:IsPreviousLocation(LOCATION_ONFIELD) and c64831019.overfil(c:GetReasonCard()) then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1,64831020)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetTarget(c64831019.sptg)
		e1:SetOperation(c64831019.spop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

function c64831019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c64831019.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end

function c64831019.jumpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==0
end
function c64831019.jumpfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_TUNER) and c:IsSetCard(0x5410) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c64831019.jumptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c64831019.jumpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) and not Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(c64831019.jumpfil,tp,LOCATION_DECK,0,1,nil) then
			local op=Duel.SelectOption(tp,aux.Stringid(64831019,0),aux.Stringid(64831019,1),aux.Stringid(64831019,2))
			if op~=2 then
				local g=Duel.SelectMatchingCard(tp,c64831019.jumpfil,tp,LOCATION_DECK,0,1,1,nil)
				if op==0 then
					Duel.SendtoHand(g,tp,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				elseif op==1 then
					Duel.SendtoGrave(g,REASON_EFFECT)
				end
			end
		end
	end
end