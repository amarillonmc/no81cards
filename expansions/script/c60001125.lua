--圣兽装骑·鲨-闲逛
local m=60001125
local cm=_G["c"..m]

function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x562e),1,1)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e21:SetCode(EVENT_SPSUMMON_SUCCESS)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetTarget(cm.shtg)
	e21:SetOperation(cm.shop)
	c:RegisterEffect(e21)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e27=Effect.CreateEffect(c)
	e27:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e27:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e27:SetCode(EVENT_ADJUST)
	e27:SetOperation(cm.gravecheckop)
	Duel.RegisterEffect(e27,0)
end

function cm.gravecheckop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then
		e:GetHandler():RegisterFlagEffect(0,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60001111,0))
	end
end

function cm.filter(c)
	return c:IsCode(60001126) and c:IsAbleToHand()
end

function cm.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) or Duel.GetFlagEffect(tp,m)==0
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end

function cm.tgsfilter(c,e,tp)
	return c:IsSetCard(0x562e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.tgsfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	if c:IsPreviousLocation(LOCATION_GRAVE) then
		Duel.RegisterFlagEffect(tp,m,0,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.tgsfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.splimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp) 
end

function cm.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end