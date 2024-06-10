--迷 之 森 伙 伴  红 帽 &灰 狼
local m=22348403
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348403,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348403)
	e1:SetCost(c22348403.tgcost)
	e1:SetTarget(c22348403.thtg)
	e1:SetOperation(c22348403.thop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c22348403.desreptg)
	e3:SetValue(c22348403.desrepval)
	e3:SetOperation(c22348403.desrepop)
	c:RegisterEffect(e3)
	--normal monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e4:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_REMOVE_TYPE)
	e5:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCondition(c22348403.sprcon)
	e6:SetOperation(c22348403.sprop)
	c:RegisterEffect(e6)
	
end
function c22348403.spexfilter(c)
	return c:IsFaceup() and c:IsCode(22348402,22348401) and c:IsAbleToDeckAsCost()
end
function c22348403.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c22348403.spexfilter,tp,LOCATION_EXTRA,0,nil)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and g:CheckSubGroup(aux.dncheck,2,2)
end
function c22348403.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c22348403.spexfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	local hg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function c22348403.costfilter(c)
	return c:IsAbleToGraveAsCost()
end
function c22348403.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22348403.costfilter,tp,LOCATION_HAND,0,1,c) and c:IsAbleToGraveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348403.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22348403.thfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand()
end
function c22348403.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348403.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348403.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c22348403.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,tg)~=0 and Duel.IsPlayerCanDraw(tp,1) then
			Duel.Draw(tp,1,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348403.sp2con2)
	e1:SetOperation(c22348403.sp2op2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22348403.filter1(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348403.sp2con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22348403.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348403.sp2op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348403.filter1),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348403.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c22348403.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsCode(22348402,22348401) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348403.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22348403.spfilter,tp,LOCATION_PZONE+LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	Group.Sub(g,eg)
	if chk==0 then return eg:IsExists(c22348403.repfilter,1,c,tp) and c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_PZONE) and c:IsReleasable() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:CheckSubGroup(aux.dncheck,2,2) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c22348403.desrepval(e,c)
	return c22348403.repfilter(c,e:GetHandlerPlayer())
end
function c22348403.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348403)
	local c=e:GetHandler()
	c:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Release(c,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c22348403.spfilter,tp,LOCATION_PZONE+LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	Group.Sub(g,eg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end



