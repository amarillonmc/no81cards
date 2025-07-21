--影灵衣的追忆
function c11533702.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
--  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
--  e1:SetCountLimit(1,11533702) 
--  e1:SetTarget(c11533702.target)
--  e1:SetOperation(c11533702.activate)
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetTargetRange(LOCATION_MZONE,0) 
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0xb4) end) 
	e2:SetValue(function(e,c) 
	return c:GetLevel()*100 end) 
	c:RegisterEffect(e2)
	--th
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13035077,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,11533702)
	e5:SetTarget(c11533702.target)
	e5:SetOperation(c11533702.activate)
	c:RegisterEffect(e5)
	--inactivatable
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	--e2:SetRange(LOCATION_FZONE)
	--e2:SetValue(c11533702.efilter)
	--c:RegisterEffect(e2)
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	--e2:SetRange(LOCATION_FZONE)
	--e2:SetValue(c11533702.efilter)
	--c:RegisterEffect(e2)  
	--immuse
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_FIELD) 
	--e3:SetCode(EFFECT_IMMUNE_EFFECT) 
	--e3:SetRange(LOCATION_SZONE)
	--e3:SetTargetRange(LOCATION_MZONE,0) 
	--e3:SetTarget(function(e,c) 
	--return c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL) end) 
	--e3:SetValue(function(e,te) 
	--return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsSummonLocation(LOCATION_EXTRA) and te:IsActivated() end)
	--e3:SetCondition(function(e) 
	--local tp=e:GetHandlerPlayer() 
	--return Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL) end,tp,LOCATION_MZONE,0,nil)>=2 end)
	--c:RegisterEffect(e3)
	--ind
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
	e3:SetRange(LOCATION_FZONE) 
	e3:SetTargetRange(LOCATION_MZONE,0) 
	e3:SetTarget(
		function(e,c) 
		return c:IsSetCard(0xb4) 
		end) 
	e3:SetValue(
		function(e,c)
		return c:IsSummonLocation(LOCATION_EXTRA) 
		end)
	e3:SetCondition(
		function(e) 
		local tp=e:GetHandlerPlayer() 
		return Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and (c:IsSetCard(0xb4) or c:IsType(TYPE_RITUAL)) end,tp,LOCATION_MZONE,0,nil)>=2 
		end)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(
		function(e,c) 
		return c:IsType(TYPE_RITUAL) 
		end) 
	e4:SetValue(
		function(e,c)
		return c:IsSummonLocation(LOCATION_EXTRA) 
		end)
	e4:SetCondition(
		function(e) 
		local tp=e:GetHandlerPlayer() 
		return Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and (c:IsSetCard(0xb4) or c:IsType(TYPE_RITUAL)) end,tp,LOCATION_MZONE,0,nil)>=2 
		end)
	c:RegisterEffect(e4)


end
function c11533702.rrfil(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then
		val=re:GetValue()
	end
	return c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_HAND) and (val==nil or val(re,c)~=true))
end
function c11533702.filter(c)
	return c:IsSetCard(0xb4) and c:IsAbleToHand()
end
function c11533702.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533702.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND)
end
function c11533702.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11533702.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c11533702.rrfil,tp,LOCATION_HAND,0,1,nil,tp) then
		Duel.BreakEffect() 
		local tc=Duel.SelectMatchingCard(tp,c11533702.rrfil,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()  
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RELEASE) 
		end 
	end
end










function c11533702.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te:GetHandler():IsSetCard(0xb4) and te:GetHandler():IsType(TYPE_RITUAL) and te:IsActiveType(TYPE_SPELL)
end








