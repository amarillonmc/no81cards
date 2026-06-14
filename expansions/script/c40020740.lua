--皇兽神皇 转轮猛虎
local s,id=GetID()
s.named_with_EmperorBeast=1

s.ZEUS_CODE=40020683
s.VULTURE_CODE=40020751 

function s.EmperorBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end

function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,40020683)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.thcon1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.thcon2)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function s.cfilter(c)
	return s.Grandwalker(c) and c:IsAbleToRemoveAsCost()
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1600)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:SetMaterial(nil)
	if Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
		c:CompleteProcedure()
		Duel.BreakEffect()
		Duel.Damage(1-tp,1600,REASON_EFFECT)
	end
end

function s.zeus_filter(c)
	return c:IsFaceup() and c:IsCode(s.ZEUS_CODE)
end

function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
		and Duel.IsExistingMatchingCard(s.zeus_filter,tp,LOCATION_REMOVED,0,1,nil)
end

function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.zeus_filter,tp,LOCATION_REMOVED,0,1,nil)
end

function s.vulture_filter(c)
	return c:IsFaceup() and c:IsCode(s.VULTURE_CODE)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local count = 2
		if Duel.IsExistingMatchingCard(s.vulture_filter,tp,LOCATION_MZONE,0,1,nil) then
			count = 3
		end
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=count 
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end

function s.hit_filter(c)
	return c:IsCode(s.ZEUS_CODE) or s.EmperorBeast(c)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local count = 2
	if Duel.IsExistingMatchingCard(s.vulture_filter,tp,LOCATION_MZONE,0,1,nil) then
		count = 3
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<count then return end
	Duel.ConfirmDecktop(tp,count)
	local g=Duel.GetDecktopGroup(tp,count)
	if #g==0 then return end
	local ct=g:FilterCount(s.hit_filter,nil)
	if ct>0 then
		Duel.Damage(1-tp,ct*1600,REASON_EFFECT)
	end
	Duel.BreakEffect()
	Duel.DisableShuffleCheck() 
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
