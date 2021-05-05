--宁岚绝海
function c40009415.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009415,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(c40009415.condition)
	e1:SetTarget(c40009415.target)
	e1:SetOperation(c40009415.activate)
	c:RegisterEffect(e1)   
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c40009415.regop)
	c:RegisterEffect(e4)  
end
function c40009415.filter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c40009415.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c40009415.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler())
end
function c40009415.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=5-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct1>0 and Duel.IsPlayerCanDraw(tp,ct1)
		and ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct2)
end
function c40009415.rfilter(c)
	return not c:IsSetCard(0x6f1d)
end
function c40009415.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct1=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=5-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct1>0 then
		Duel.Draw(tp,ct1,REASON_EFFECT)
	end
	if ct2>0 then
		Duel.Draw(1-tp,ct2,REASON_EFFECT)
	end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(c40009415.rfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c40009415.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(40009415,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCost(aux.bfgcost)
		e1:SetTarget(c40009415.settg)
		e1:SetOperation(c40009415.setop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
end
function c40009415.setfilter(c)
	return c:IsSetCard(0x6f1d) and c:IsType(TYPE_SPELL) and c:IsSSetable() and not c:IsCode(40009415)
end
function c40009415.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40009415.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c40009415.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c40009415.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end

