--灾厄的赤龙 阿尔比昂的左手
function c11513043.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end)
	e1:SetOperation(c11513043.sucop)
	c:RegisterEffect(e1)
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11513043) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetHandler():GetMaterial():IsExists(Card.IsType,1,nil,TYPE_RITUAL) end) 
	e1:SetTarget(c11513043.xthtg) 
	e1:SetOperation(c11513043.xthop)   
	c:RegisterEffect(e1)
end
function c11513043.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial() 
	local atk=mg:GetSum(Card.GetAttack) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_BASE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(atk) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_SET_BASE_DEFENSE) 
	c:RegisterEffect(e2) 
	if mg:IsExists(Card.IsType,1,nil,TYPE_XYZ) then 
	--des 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11513043,1))
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetTarget(c11513043.destg)
	e1:SetOperation(c11513043.desop) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	end 
	if mg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then 
	--all 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11513043,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	end 
	if mg:IsExists(Card.IsType,1,nil,TYPE_LINK) then 
	--rl and sp 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11513043,3))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)  
	e1:SetTarget(c11513043.rsptg) 
	e1:SetOperation(c11513043.rspop) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(function(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler() end)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
	end 
	if mg:IsExists(Card.IsType,1,nil,TYPE_RITUAL) then  
	c:RegisterFlagEffect(11513043,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11513043,4))
	end 
	if mg:IsExists(Card.IsType,1,nil,TYPE_FUSION) then 
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11513043,5))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	end 
	if mg:IsExists(Card.IsType,1,nil,TYPE_PENDULUM) then 
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11513043,6))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE)) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	end 
end  
function c11513043.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end 
function c11513043.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
	Duel.Destroy(g,REASON_EFFECT)
	end 
end 
function c11513043.rspfil(c,e,tp)  
	local atk=e:GetHandler():GetBaseAttack()
	return c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:GetAttack()<atk and Duel.GetMZoneCount(tp,e:GetHandler())>0  
end  
function c11513043.rsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c11513043.rspfil,tp,LOCATION_HAND,0,1,nil,e,tp) and e:GetHandler():GetFlagEffect(13713043)==0 end 
	e:GetHandler():RegisterFlagEffect(13713043,RESET_CHAIN,0,1)  
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end 
function c11513043.rspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513043.rspfil,tp,LOCATION_HAND,0,nil,e,tp) 
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)~=0 and g:GetCount()>0 then  
		local sc=g:Select(tp,1,1,nil):GetFirst() 
		sc:SetMaterial(Group.FromCards(c))  
		Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) 
		if Duel.GetTurnPlayer()~=tp then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		sc:RegisterEffect(e1)
		end 
	end 
end  
function c11513043.xthfil(c) 
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand() 
end 
function c11513043.xthgck(g) 
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)==1 
	   and g:FilterCount(Card.IsType,nil,TYPE_SPELL)==1 
end 
function c11513043.xthtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(c11513043.xthfil,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(c11513043.xthgck,2,2) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_DECK) 
end 
function c11513043.xthop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513043.xthfil,tp,LOCATION_DECK,0,nil) 
	if g:CheckSubGroup(c11513043.xthgck,2,2) then 
	local sg=g:SelectSubGroup(tp,c11513043.xthgck,false,2,2) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end 


