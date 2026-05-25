--堕污邪灵之眼
function c79640012.initial_effect(c)
	--same effect send this card to grave and spsummon another card check
	local e01=aux.AddThisCardInGraveAlreadyCheck(c)
	--search
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(79640012,0))
	e0:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SSET)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,79640012)
	e0:SetCost(c79640012.thcost)
	e0:SetTarget(c79640012.thtg)
	e0:SetOperation(c79640012.thop)
	c:RegisterEffect(e0) 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79640012,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,79640012+100)
	e1:SetLabelObject(e01)
	e1:SetCost(c79640012.cost)
	e1:SetCondition(c79640012.spcon)
	e1:SetTarget(c79640012.sptg)
	e1:SetOperation(c79640012.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(79640012,ACTIVITY_SPSUMMON,c79640012.counterfilter) 
end
function c79640012.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or (c:IsType(TYPE_FUSION) and c:IsRace(RACE_SPELLCASTER+RACE_DRAGON)) or c:IsSetCard(0xab0) 
end
function c79640012.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.GetCustomActivityCount(79640012,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79640012.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79640012.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not ((c:IsType(TYPE_FUSION) and c:IsRace(RACE_SPELLCASTER+RACE_DRAGON)) or c:IsSetCard(0xab0)) and c:IsLocation(LOCATION_EXTRA)
end
function c79640012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,1,nil) end
end
function c79640012.thfilter(c)
	if not (c:IsSetCard(0xab0) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c79640012.cfilter(c)
	return (c:IsFacedown() or not c:IsCode(79640012)) and c:IsType(TYPE_MONSTER)
end
function c79640012.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleHand(1-tp)
	end
	local g=Duel.GetMatchingGroup(c79640012.thfilter,tp,LOCATION_DECK,0,nil)
	if not Duel.IsExistingMatchingCard(c79640012.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) 
	and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(79640012,2)) then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=Duel.SelectMatchingCard(tp,c79640012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=sg:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.		 SelectOption(tp,1190,1153)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SSet(tp,tc)
			end
		end
	end
end
function c79640012.spfilter(c,tp,se)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0xab0)
		and (se==nil or c:GetReasonEffect()~=se)
end
function c79640012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79640012.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79640012.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(c79640012.spfilter,1,nil,tp,se)
end
function c79640012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79640012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end