--盛饰的恶魔
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg2)
	e2:SetOperation(cm.thop2)
	c:RegisterEffect(e2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--attackup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(cm.incon)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(cm.incon)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	--Evolve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.incon)
	e3:SetTarget(cm.atg)
	e3:SetOperation(cm.aop)
	c:RegisterEffect(e3)
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c,tp)
	return c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(tp,0x624,1,c) and not c:IsCode(m) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsRace(RACE_FIEND)
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Draw(tp,3,REASON_EFFECT)==3 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
		local cg=Duel.GetMatchingGroup(cm.dfil,tp,LOCATION_HAND,0,nil,tp)
		g:Sub(cg)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
end
function cm.dfil(c,tp)
	return c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(tp,0x624,1,c) and c:IsType(TYPE_MONSTER)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.atg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.aop(e,tp,eg,ep,ev,re,r,rp)
	local st=2
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then st=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,st,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end