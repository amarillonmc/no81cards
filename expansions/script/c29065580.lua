--方舟骑士·风笛
function c29065580.initial_effect(c)
	c:EnableCounterPermit(0x87ae)
	c:SetSPSummonOnce(29065580)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x87af),2,2) 
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065580,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c29065580.cocon)
	e1:SetOperation(c29065580.coop)
	c:RegisterEffect(e1)
	--counter
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e5:SetCost(c29065580.thcost)
	e5:SetTarget(c29065580.thtg)
	e5:SetOperation(c29065580.thop)
	c:RegisterEffect(e5)
	--COUNTER
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(29065580)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)   
end

function c29065580.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsCanAddCounter(0x87ae,2)
end
function c29065580.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c29065580.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065580.thfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
end
function c29065580.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c29065580.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	local n=2 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	tc:AddCounter(0x87ae,n)
end
function c29065580.cocon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCanAddCounter(0x87ae,1) and e:GetHandler():IsRelateToBattle()
end
function c29065580.coop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	c:AddCounter(0x87ae,n)
end





