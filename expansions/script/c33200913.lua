--寒霜灵兽 冰鬼护
function c33200913.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,33200913)
	e1:SetCost(c33200913.spcost)
	e1:SetTarget(c33200913.sptg)
	e1:SetOperation(c33200913.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200913,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,33210913)
	e2:SetTarget(c33200913.thtg)
	e2:SetOperation(c33200913.thop)
	c:RegisterEffect(e2) 
	--counter
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33200913,0))
	e0:SetCategory(CATEGORY_COUNTER)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetTarget(c33200913.cttg)
	e0:SetOperation(c33200913.ctop)
	c:RegisterEffect(e0)
	local e3=e0:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33200913,2))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33200913.reccon)
	e4:SetTarget(c33200913.rectg)
	e4:SetOperation(c33200913.recop)
	c:RegisterEffect(e4) 
end

--e1
function c33200913.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST)
end
function c33200913.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c33200913.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e2
function c33200913.thfilter(c)
	return c:IsSetCard(0x332a) and c:IsType(TYPE_MONSTER) and not c:IsCode(33200913) and c:IsAbleToHand()
end
function c33200913.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200913.thfilter,tp,LOCATION_DECK,0,1,nil) and (e:GetHandler():IsLocation(LOCATION_MZONE) or (e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsAbleToExtra())) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if e:GetHandler():IsLocation(LOCATION_HAND) then 
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),nil,0,LOCATION_HAND)
	elseif e:GetHandler():IsLocation(LOCATION_MZONE) then 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),nil,0,LOCATION_MZONE)
	end
end
function c33200913.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33200913.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			if e:GetHandler():IsLocation(LOCATION_ONFIELD) then
				Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
			elseif e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsAbleToExtra() then 
				Duel.SendtoExtraP(e:GetHandler(),tp,REASON_EFFECT)
			end
		end
	end
end

--e3
function c33200913.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x132a,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x132a)
end
function c33200913.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):Filter(Card.IsCanAddCounter,nil,0x132a,1)
	for tc in aux.Next(g) do
		if tc:IsCanAddCounter(0x132a,1) then
			tc:AddCounter(0x132a,1)
		end
	end
end

--e4
function c33200913.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33200900)>0
end
function c33200913.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c33200913.recop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,33200900)>0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
