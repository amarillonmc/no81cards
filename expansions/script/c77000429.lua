--邪心英雄 邪惑魔
function c77000429.initial_effect(c)
	aux.AddCodeList(c,94820406)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6008),aux.FilterBoolFunction(Card.IsFusionSetCard,0x8),true) 
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
	return se:GetHandler():IsCode(94820406)
		or Duel.IsPlayerAffectedByEffect(sp,72043279) and st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION end)
	c:RegisterEffect(e1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,77000429)  
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e1:SetTarget(c77000429.thtg)
	e1:SetOperation(c77000429.thop)
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsRace(RACE_FIEND) end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*100 end) 
	c:RegisterEffect(e2) 
	--change 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(77000429,1)) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(2) 
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e3:SetTarget(c77000429.cgtg) 
	e3:SetOperation(c77000429.cgop) 
	c:RegisterEffect(e3) 
end 
c77000429.material_setcode=0x8
c77000429.dark_calling=true
function c77000429.thfil(c)
	return (aux.IsCodeListed(c,94820406) or c:IsCode(94820406)) and not c:IsCode(77000429) and c:IsAbleToHand()
end
function c77000429.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77000429.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77000429.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77000429.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 
function c77000429.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and (not c:IsRace(RACE_FIEND) or not c:IsAttribute(ATTRIBUTE_DARK)) end,tp,0,LOCATION_MZONE,1,nil) end 
end 
function c77000429.cgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and (not c:IsRace(RACE_FIEND) or not c:IsAttribute(ATTRIBUTE_DARK)) end,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_RACE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(RACE_FIEND) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(ATTRIBUTE_DARK) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)  
	end 
end 



