--无形噬体·还原粒
function c49811231.initial_effect(c)
	c:SetSPSummonOnce(49811231)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c49811231.matfilter,1,1)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c49811231.tgcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(c49811231.slcon)
	e3:SetTarget(c49811231.sltg)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,49811231)
	e4:SetTarget(c49811231.thtg)
	e4:SetOperation(c49811231.thop)
	c:RegisterEffect(e4)
end
function c49811231.matfilter(c)
	return c:IsSetCard(0xe0) and (c:IsSummonType(SUMMON_TYPE_NORMAL) or c:IsSummonType(SUMMON_TYPE_PENDULUM))
end
function c49811231.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c49811231.tgcon(e)
	return Duel.IsExistingMatchingCard(c49811231.tgfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil)
end
function c49811231.slfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0) and c:IsType(TYPE_PENDULUM)
end
function c49811231.slcon(e)
	return Duel.IsExistingMatchingCard(c49811231.slfilter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,1,nil)
end
function c49811231.sltg(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xe0)
end
function c49811231.thfilter(c)
	return c:IsCode(98287529) and c:IsAbleToHand()
end
function c49811231.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811231.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49811231.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c49811231.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end