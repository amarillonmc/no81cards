local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,id+1)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rp==tp and re:GetHandler():IsSetCard(0xae51) 
	and bit.band(loc,LOCATION_ONFIELD)==0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then return #g>0  end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.thop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function s.filter1(c)
	return c:IsSetCard(0xae51) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
end

function s.spfilter(c,tp)
	return (c:IsSetCard(0xae51) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()) and not c:IsCode(id)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.spfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
   if tc:IsRelateToChain() and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_HAND) and c:IsRelateToChain() then
Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if  Duel.SelectYesNo(tp,aux.Stringid(id,2)) and Duel.IsExistingMatchingCard(s.efffilter,tp,LOCATION_HAND,0,1,nil,tp) then
		
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,s.efffilter,tp,LOCATION_HAND,0,1,1,nil)
Duel.ConfirmCards(1-tp,sg)
if #sg>0 and sg:GetFirst():IsLevelBelow(5) then
	local att=sg:GetFirst():GetAttribute()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,att)
	if #g>0 and sg:GetFirst():IsDiscardable() then
			 
			   Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
				 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				 local fg=g:Select(tp,1,1,nil)
				 Duel.SendtoHand(fg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,fg)
	end

elseif sg:GetFirst():IsLevelAbove(5) then

			 local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(sg:GetFirst():GetLevel()*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	   
	 end
			end
end
	end


function s.atkfilter(c)
	return c:IsSetCard(0xae51) and c:IsType(TYPE_MONSTE) and c:IsAbleToGrave()
end
function s.efffilter(c,tp)
   return c:IsSetCard(0xae51) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.efffilter1,tp,LOCATION_DECK,0,1,nil,c:GetLevel(),c:GetAttribute())
end
function s.efffilter1(c,lv,att)
   return c:IsSetCard(0xae51) and c:IsType(TYPE_MONSTER) and ((c:IsAbleToHand() and not c:IsAttribute(att)) or (c:IsAbleToGrave()))
end
function s.thfilter(c,att)
   return c:IsSetCard(0xae51) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(att)
end