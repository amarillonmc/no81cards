--深腐诞地 噬骨鲨
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon rule
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.sprcon)
	e0:SetOperation(s.sprop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+o*1000)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.damcon)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(s.damcon2)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end
function s.spfilter(c,tp,f)
	return f(c) and Duel.GetMZoneCount(tp,c)>0 and (c:IsSetCard(0x569) or c:IsRace(RACE_ZOMBIE))
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp,Card.IsAbleToGraveAsCost)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp,Card.IsAbleToGraveAsCost)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.thfilter(c)
	return not c:IsCode(id) and c:IsSetCard(0x6569) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.cfilter(c)
	return c:GetCounter(0x0569)>0
end
function s.iee(c)
	return c:GetCounter(0x0569)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(s.cfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)
	local ct=sg:GetSum(s.iee)
	return ct>0 and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(s.cfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)
	local ct=sg:GetSum(s.iee)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and ct>0 and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	tp=e:GetHandlerPlayer()
	local sg=Duel.GetMatchingGroup(s.cfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)
	local ct=Duel.GetCounter(tp,1,0,0x0569)--sg:GetSum(s.iee)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end