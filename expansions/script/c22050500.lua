--悲叹之律－狂想曲
function c22050500.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22050500,0))
	e2:SetProperty(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,22050500)
	e2:SetCost(c22050500.cost)
	e2:SetTarget(c22050500.target)
	e2:SetOperation(c22050500.operation)
	c:RegisterEffect(e2)
	--2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22050500,1))
	e3:SetProperty(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,22050501)
	e3:SetCost(c22050500.cost2)
	e3:SetTarget(c22050500.target2)
	e3:SetOperation(c22050500.operation)
	c:RegisterEffect(e3)
	--3
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22050500,2))
	e4:SetProperty(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCountLimit(1,22050502)
	e4:SetCost(c22050500.cost3)
	e4:SetTarget(c22050500.target3)
	e4:SetOperation(c22050500.operation)
	c:RegisterEffect(e4)
	--4
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22050500,3))
	e5:SetProperty(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCountLimit(1,22050503)
	e5:SetCost(c22050500.cost4)
	e5:SetTarget(c22050500.target4)
	e5:SetOperation(c22050500.operation)
	c:RegisterEffect(e5)
	--5
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22050500,4))
	e6:SetProperty(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetCountLimit(1,22050504)
	e6:SetCost(c22050500.cost5)
	e6:SetTarget(c22050500.target5)
	e6:SetOperation(c22050500.operation)
	c:RegisterEffect(e6)
end
function c22050500.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xfec,2,REASON_COST) end
	e:GetHandler():RegisterFlagEffect(22050500,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c22050500.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xfec,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xfec,2,REASON_COST)
	e:GetHandler():RegisterFlagEffect(22050501,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c22050500.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xfec,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xfec,3,REASON_COST)
	e:GetHandler():RegisterFlagEffect(22050502,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c22050500.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xfec,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xfec,4,REASON_COST)
	e:GetHandler():RegisterFlagEffect(22050503,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c22050500.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xfec,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xfec,5,REASON_COST)
end
function c22050500.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and  c:IsSetCard(0xff8) and c:IsAbleToGrave()
end
function c22050500.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22050500.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c22050500.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22050500.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c22050500.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22050500.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) and c:GetFlagEffect(22050500)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c22050500.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22050500.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) and c:GetFlagEffect(22050501)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c22050500.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22050500.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) and c:GetFlagEffect(22050502)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c22050500.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22050500.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) and c:GetFlagEffect(22050503)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
