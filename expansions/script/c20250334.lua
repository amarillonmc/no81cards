--禁钉显迹受领机
function c20250334.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20250334,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,20250334)
	e1:SetCost(c20250334.spcost)
	e1:SetTarget(c20250334.sptg)
	e1:SetOperation(c20250334.spop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(c20250334.tnval)
	c:RegisterEffect(e2)
	--lv
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetCondition(c20250334.tnval)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(0)
	e4:SetCondition(c20250334.dckcon) 
	e4:SetOperation(c20250334.dckop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CUSTOM+20250334) 
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,20250335)
	e5:SetCondition(c20250334.descon)
	e5:SetTarget(c20250334.target)
	e5:SetOperation(c20250334.activate)
	c:RegisterEffect(e5)
end
function c20250334.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x154a,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x154a,1,REASON_COST)
end
function c20250334.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c20250334.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		c:AddCounter(0x154a,1)
	end
end
function c20250334.tnval(e)
	return e:GetHandler():GetCounter(0x154a)>0
end
function c20250334.dckcon(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetFlagEffect(20250334)
	return x~=e:GetHandler():GetCounter(0x154a)
end 
function c20250334.dckop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	c:ResetFlagEffect(20250334)
		local ct=c:GetCounter(0x154a)
		for i=1,ct do
		c:RegisterFlagEffect(20250334,RESET_EVENT+0x1fe0000,0,1)
	end
		if e:GetHandler():GetCounter(0x154a)==0 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+20250334,e,0,0,tp,0) 
	end
end
function c20250334.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x154a)==0 
end
function c20250334.thfilter(c)
	return c:IsSetCard(0x54a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c20250334.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20250334.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20250334.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20250334.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end