--影灵衣的追忆
function c11533702.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11533702) 
	e1:SetTarget(c11533702.target)
	e1:SetOperation(c11533702.activate)
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetTargetRange(LOCATION_MZONE,0) 
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0xb4) end) 
	e2:SetValue(function(e,c) 
	return c:GetLevel()*100 end) 
	c:RegisterEffect(e2)
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
	e3:SetTarget(function(e,c) 
	return c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL) end) 
	e3:SetValue(function(e,c)
	return c:IsSummonLocation(LOCATION_EXTRA) end) 
	e3:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL) end,tp,LOCATION_MZONE,0,nil)>=3 end)
	c:RegisterEffect(e3)
end
function c11533702.filter(c)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11533702.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533702.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11533702.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11533702.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11533702.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te:GetHandler():IsSetCard(0xb4) and te:GetHandler():IsType(TYPE_RITUAL) and te:IsActiveType(TYPE_SPELL)
end








