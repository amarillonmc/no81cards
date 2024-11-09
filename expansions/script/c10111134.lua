function c10111134.initial_effect(c)
	aux.AddCodeList(c,10111128)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111134,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10111134)
	e1:SetTarget(c10111134.rmtg)
	e1:SetOperation(c10111134.rmop)
	c:RegisterEffect(e1)
        	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111134,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101111340)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10111134.thtg)
	e2:SetOperation(c10111134.thop)
	c:RegisterEffect(e2)
    	 --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10111134,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,101111341)
	e3:SetCondition(c10111134.spcon)
	e3:SetTarget(c10111134.sptg)
	e3:SetOperation(c10111134.spop)
	c:RegisterEffect(e3)
    end
function c10111134.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c10111134.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111134.rmfilter,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c10111134.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10111134.rmfilter,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()==0 then return end
	Duel.ShuffleExtra(1-tp)
	local tc=g:RandomSelect(tp,1):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	local atk=tc:GetAttack()
	local c=e:GetHandler()
	local og2=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	local tc=og2:GetFirst()
	while tc do
	tc:RegisterFlagEffect(10111134,RESET_EVENT+RESETS_STANDARD,0,1)
	tc=og2:GetNext()
	if atk<0 then atk=0 end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    og2:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk/2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e2:SetLabelObject(og2)
	e2:SetCountLimit(1)
	e2:SetCondition(c10111134.retcon)
	e2:SetOperation(c10111134.retop)
	Duel.RegisterEffect(e2,tp)
   end
end
function c10111134.retfilter(c)
	return c:GetFlagEffect(10111134)~=0
end
function c10111134.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end    
function c10111134.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c10111134.retfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	g:DeleteGroup()
end
function c10111134.thfilter(c)
	return aux.IsCodeOrListed(c,10111128) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c10111134.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111134.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10111134.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10111134.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10111134.cfilter(c,tp)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsCode(10111134) and c:IsControler(tp)
end
function c10111134.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10111134.cfilter,1,nil,tp)
end
function c10111134.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10111134.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end