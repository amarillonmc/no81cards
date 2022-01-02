--逆转辩护士 成步堂龙一
function c33200511.initial_effect(c)
	aux.AddCodeList(c,33200500)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200511,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200511)
	e1:SetCondition(c33200511.spcon)
	e1:SetTarget(c33200511.sptg)
	e1:SetOperation(c33200511.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200511,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c33200511.thtg)
	e2:SetOperation(c33200511.thop)
	c:RegisterEffect(e2)
	--TZ
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33200511.condition)
	e3:SetTarget(c33200511.tztg)
	e3:SetOperation(c33200511.tzop)
	c:RegisterEffect(e3)
end

--e1
function c33200511.spcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c33200511.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33200511.spcfilter,1,nil,tp)
end
function c33200511.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33200511.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
end

--e2
function c33200511.thfilter(c)
	return aux.IsCodeListed(c,33200511) and c:IsAbleToHand() and not c:IsCode(33200508)
end
function c33200511.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200511.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33200511.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33200511.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--e3
function c33200511.exfilter(c)
   return not c:IsPublic()
end
function c33200511.rmfilter(c,opt)
   return (opt==0 and c:IsType(TYPE_MONSTER)) or (opt==1 and c:IsType(TYPE_SPELL)) or (opt==2 and c:IsType(TYPE_TRAP)) and c:IsAbleToRemove() and c:IsFaceup()
end
function c33200511.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c33200511.tztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tm=Duel.GetFlagEffect(tp,33200503)
	if chk==0 then return Duel.GetFlagEffect(tp,e:GetHandler():GetOriginalCode())<tm+1 and Duel.IsExistingMatchingCard(c33200511.exfilter,tp,0,LOCATION_HAND,1,nil) end
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(33200500,RESET_EVENT+RESET_CHAIN,0,1)
end
function c33200511.tzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=3
	if re:GetHandler():IsType(TYPE_MONSTER) then opt=0 end
	if re:GetHandler():IsType(TYPE_SPELL) then opt=1 end
	if re:GetHandler():IsType(TYPE_TRAP) then opt=2 end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	if not Duel.IsPlayerAffectedByEffect(tp,33200505) then
		local sg=g:Filter(c33200511.exfilter,nil):RandomSelect(1-tp,1)
		local sgc=sg:GetFirst()
		Duel.ConfirmCards(tp,sgc)
		Duel.ShuffleHand(1-tp)
		if (opt==0 and sgc:IsType(TYPE_MONSTER)) or (opt==1 and sgc:IsType(TYPE_SPELL)) or (opt==2 and sgc:IsType(TYPE_TRAP)) then
			if Duel.NegateActivation(ev) then Duel.Recover(tp,800,REASON_EFFECT) end
		end
	else
		Duel.ConfirmCards(tp,g)
		local sg=Duel.SelectMatchingCard(tp,c33200511.exfilter,tp,0,LOCATION_HAND,1,1,nil)
		local sgc=sg:GetFirst()
		Duel.ShuffleHand(1-tp)
		if (opt==0 and sgc:IsType(TYPE_MONSTER)) or (opt==1 and sgc:IsType(TYPE_SPELL)) or (opt==2 and sgc:IsType(TYPE_TRAP)) then
			if Duel.NegateActivation(ev) then Duel.Recover(tp,800,REASON_EFFECT) end
		end
	end
end
