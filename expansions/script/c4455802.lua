--西洋棋 皇后
function c4455802.initial_effect(c)
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(4455802,0))
	e1:SetCategory(CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_CHAINING) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,4455802)
	e1:SetCondition(c4455802.xcon) 
	e1:SetTarget(c4455802.thtg) 
	e1:SetOperation(c4455802.thop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(4455802,1))
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,4455802)
	e2:SetCondition(c4455802.xcon) 
	e2:SetTarget(c4455802.sptg) 
	e2:SetOperation(c4455802.spop) 
	c:RegisterEffect(e2) 
	--dis 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(4455802,2)) 
	e3:SetCategory(CATEGORY_DISABLE) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_TO_HAND) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,1455802) 
	e3:SetCondition(c4455802.discon)
	e3:SetTarget(c4455802.distg) 
	e3:SetOperation(c4455802.disop) 
	c:RegisterEffect(e3) 
end 
c4455802.SetCard_YLchess=true
function c4455802.xcon(e,tp,eg,ep,ev,re,r,rp)   
	return re:GetHandler().SetCard_YLchess and rp==tp 
end 
function c4455802.thfil(c) 
	return c:IsAbleToHand() and c.SetCard_YLchess  
end  
function c4455802.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c4455802.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c4455802.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c4455802.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then   
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end 
function c4455802.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(4455802) 
end  
function c4455802.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c4455802.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK) 
end 
function c4455802.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c4455802.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil)  
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end  
function c4455802.ckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_GRAVE) and c.SetCard_YLchess  
end 
function c4455802.discon(e,tp,eg,ep,ev,re,r,rp)   
	return eg:IsExists(c4455802.ckfil,1,nil,tp)
end 
function c4455802.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingTarget(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end 
function c4455802.disop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end








