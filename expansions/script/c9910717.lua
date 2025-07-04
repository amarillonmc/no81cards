--远古造物大灭绝
dofile("expansions/script/c9910700.lua")
function c9910717.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910717,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910717+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910717.target)
	e1:SetOperation(c9910717.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910717,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9910717+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c9910717.cost)
	e2:SetTarget(c9910717.target2)
	e2:SetOperation(c9910717.activate2)
	c:RegisterEffect(e2)
	if not c9910717.global_check then
		c9910717.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MSET)
		ge1:SetOperation(c9910717.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHANGE_POS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_SSET)
		Duel.RegisterEffect(ge4,0)
	end
end
function c9910717.checkfilter(c,p)
	return c:IsFacedown() and c:IsControler(p)
end
function c9910717.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	if (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and eg:IsExists(c9910717.checkfilter,1,nil,p) and Duel.GetFlagEffect(1-p,9910717)==0 then
		Duel.RegisterFlagEffect(1-p,9910717,0,0,1)
		Duel.SelectYesNo(1-p,aux.Stringid(9910717,2))
	end
end
function c9910717.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c9910717.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetTargetRange(0,1)
		e3:SetValue(0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c9910717.cfilter(c)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function c9910717.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910717.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910717.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910717.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9910717.chlimit)
	end
end
function c9910717.chlimit(e,ep,tp)
	return tp==ep
end
function c9910717.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetTargetRange(0,1)
		e3:SetValue(0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(c9910717.setop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910717.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910717)
	local ct=Duel.GetMatchingGroupCount(QutryYgzw.SetFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	ct=math.min(ct,ft,3)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,QutryYgzw.SetFilter,tp,LOCATION_MZONE,LOCATION_MZONE,ct,ct,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		QutryYgzw.Set2(sg,e,tp)
	end
end
