local m=65809251
local cm=_G["c"..m]
cm.name="策略 阶级固化"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DISCARD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.atkcon)
	e3:SetTarget(cm.atktg)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
function cm.disfilter1(c)
	return c:IsSetCard(0xaa30) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.disfilter2(c,e,tp)
	return c:IsSetCard(0xca30) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check1=eg:FilterCount(function(c,tp) return c:GetOwner()==tp end,nil,tp)>0
	local check2=eg:FilterCount(function(c,tp) return c:GetOwner()==tp end,nil,1-tp)>0
	if chk==0 then
		local res=true
		if check1 then res=res and Duel.IsExistingMatchingCard(cm.disfilter1,tp,LOCATION_DECK,0,1,nil) end
		if check2 then res=res and Duel.IsExistingMatchingCard(cm.disfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
		return res
	end
	if check1 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) end
	if check2 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK) end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local check1=eg:FilterCount(function(c,tp) return c:GetOwner()==tp end,nil,tp)>0
	local check2=eg:FilterCount(function(c,tp) return c:GetOwner()==tp end,nil,1-tp)>0
	if check2 and Duel.IsExistingMatchingCard(cm.disfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		local spc=Duel.SelectMatchingCard(tp,cm.disfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(spc,0,tp,1-tp,false,false,POS_FACEUP)
	end
	if check1 and Duel.IsExistingMatchingCard(cm.disfilter1,tp,LOCATION_DECK,0,1,nil) then
		local g=Duel.SelectMatchingCard(tp,cm.disfilter1,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return rp==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xaa30) and not c:IsCode(m)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(-500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end