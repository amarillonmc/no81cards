--电子龙·统治
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,3659803,23171610)
	--link summon
	aux.AddLinkProcedure(c,s.mfilter,2,2)
	c:EnableReviveLimit()   
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.mfilter(c)
	return c:IsLinkSetCard(0x93) and c:IsLinkRace(RACE_MACHINE)
end
function s.cfilter(c)
	return c:IsSetCard(0x93) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and #g>=3 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.cfilter),tp,LOCATION_GRAVE,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,1,99,nil)
	local ct=Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)//3
	if ct and ct>=1 then
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end

function s.filter(c)
	if not c:IsAbleToHand() then return false end
	return c:IsSetCard(0x93,0x94) and c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsCode(3659803,23171610)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end