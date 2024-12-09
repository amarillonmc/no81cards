--A－救牙竜
local s,id=GetID()
function s.initial_effect(c)
	--to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.thcon)
    e1:SetCost(s.thcost)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToHand() and (c:GetAttack()+c:GetDefense()==2700)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)		
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsSummonableCard() and re:GetHandler():GetLocation()==LOCATION_MZONE and re:GetHandler():GetControler()==tp
end
function s.Getattackanddefense(c)
	return c:GetAttack()+c:GetDefense()
end
function s.srmfilter(c,value)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(tp,POS_FACEUP,REASON_EFFECT) and (s.Getattackanddefense(c)<=value) and (s.Getattackanddefense(c)>0)
end
function s.unfilter(c)
	return (c:IsLocation(LOCATION_HAND) and not c:IsPublic()) or (c:IsLocation(LOCATION_EXTRA) and c:IsFacedown())
end
function s.pufilter(c,tp)
	return (c:IsLocation(LOCATION_HAND) and c:IsPublic() and (s.Getattackanddefense(c)>0) and c:IsAbleToRemove(1-tp,POS_FACEUP,REASON_RULE)) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and (s.Getattackanddefense(c)>0) and c:IsAbleToRemove(1-tp,POS_FACEUP,REASON_RULE))
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local value=10000
	local og=Duel.GetMatchingGroup(s.unfilter,tp,0,LOCATION_HAND+LOCATION_EXTRA,nil)
	local og2=Duel.GetMatchingGroup(s.pufilter,tp,0,LOCATION_HAND+LOCATION_EXTRA,nil,tp)
	if #og==0 and #og2>0 then
		local mg,mvalue=og2:GetMinGroup(s.Getattackanddefense)
		value=mvalue
		--local tc=og2:GetFirst()
		--while tc do			
		--	local tvalue=(s.Getattackanddefense(tc))
		--	if value>tvalue then
		--		value=tvalue
		--	end
		--end
	end
	if chk==0 then return (#og>0 or #og2>0) and Duel.IsPlayerCanRemove(1-tp) and Duel.IsExistingMatchingCard(s.srmfilter,tp,LOCATION_HAND,0,1,nil,value) end
	local sg=Duel.GetMatchingGroup(s.srmfilter,tp,LOCATION_HAND,0,nil,value)
	Group.Merge(og,og2)
	Group.Merge(og,sg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,og,2,0,0)
end
--function s.fselect(g,svalue)
--	Duel.SetSelectedCard(g)
--	return g:CheckWithSumGreater(s.Getattackanddefense,svalue)
--end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local value=10000
	local og=Duel.GetMatchingGroup(s.unfilter,tp,0,LOCATION_HAND+LOCATION_EXTRA,nil)
	local og2=Duel.GetMatchingGroup(s.pufilter,tp,0,LOCATION_HAND+LOCATION_EXTRA,nil,tp)
	if #og==0 and #og2>0 then
		local mg,mvalue=og2:GetMinGroup(s.Getattackanddefense)
		value=mvalue
		--local tc=og2:GetFirst()
		--while tc do			
		--	local tvalue=(s.Getattackanddefense(tc))
		--	if value>tvalue then
		--		value=tvalue
		--	end
		--end
	end
	local sg=Duel.GetMatchingGroup(s.srmfilter,tp,LOCATION_HAND,0,nil,value)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=sg:Select(tp,1,1,nil):GetFirst()
	Duel.Remove(rc,POS_FACEUP,REASON_EFFECT,tp)
	local svalue=s.Getattackanddefense(rc)
	Group.Merge(og,og2)
	local addvalue=og:GetSum(s.Getattackanddefense)
	if not (Duel.IsPlayerCanRemove(1-tp) and addvalue>=svalue) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	--local rg2=og:SelectSubGroup(1-tp,s.fselect,false,1,#og,svalue)
	local rg2=og:SelectWithSumGreater(1-tp,s.Getattackanddefense,svalue)
	Duel.Remove(rg2,POS_FACEUP,REASON_RULE,1-tp)
end