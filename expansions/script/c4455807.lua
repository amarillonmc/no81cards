--西洋棋王车易位
function c4455807.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4455807)
	e1:SetTarget(c4455807.thtg)
	e1:SetOperation(c4455807.thop)
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1,1455807) 
	e2:SetTarget(c4455807.sptg) 
	e2:SetOperation(c4455807.spop) 
	c:RegisterEffect(e2) 
	--Release
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(4455807,2)) 
	e3:SetCategory(CATEGORY_RELEASE) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_TO_HAND) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,2455807) 
	e3:SetCondition(c4455807.rlcon)
	e3:SetTarget(c4455807.rltg) 
	e3:SetOperation(c4455807.rlop) 
	c:RegisterEffect(e3) 
end 
c4455807.SetCard_YLchess=true
function c4455807.thfilter(c)
	return c.SetCard_YLchess and c:IsAbleToHand()
end
function c4455807.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4455807.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4455807.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4455807.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.ShuffleDeck(tp)
		tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end 
end 
function c4455807.ckfil(c) 
	return c:IsFaceup() and c:IsCode(4455804)  
end 
function c4455807.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(4455801)  
end 
function c4455807.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4455807.ckfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c4455807.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end 
function c4455807.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c4455807.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then 
	Duel.BreakEffect() 
	--direct atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c.SetCard_YLchess end)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)  
	end  
	end 
end 
function c4455807.rckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_GRAVE) and c.SetCard_YLchess  
end 
function c4455807.rlcon(e,tp,eg,ep,ev,re,r,rp)   
	return eg:IsExists(c4455807.rckfil,1,nil,tp)
end  
function c4455807.rlfil(c) 
	return c:IsReleasable() and c:IsCode(4455804) and c:IsFaceup() 
end 
function c4455807.rltg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c4455807.rlfil,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
end 
function c4455807.rlop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup() 
	if g:GetCount()>0 then 
	local rg=g:Select(tp,1,1,nil) 
	if Duel.Release(rg,REASON_EFFECT)~=0 then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c) 
	return c.SetCard_YLchess end)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp) 
	end  
	end 
end 








