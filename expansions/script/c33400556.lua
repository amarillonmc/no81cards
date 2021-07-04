--四糸奈 冰结之兽
local m=33400556
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 --destroy
   local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(cm.cost2)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
  --remain field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e4)
end
function cm.ckfilter(c)
	return c:IsSetCard(0x6341) and c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsCanRemoveCounter(tp,1,1,0x1015,4,REASON_COST) and (Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil) )end
	if not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)then Duel.PayLPCost(tp,1000)
	end
	Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,1))
	Duel.RemoveCounter(tp,1,1,0x1015,4,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	Duel.BreakEffect()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
	   local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	   Duel.Destroy(tc,REASON_EFFECT)
   end 
end

function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and (Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)) end
	 if not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)then Duel.PayLPCost(tp,1000)
	end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local d=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1015)
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(d*100)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=g:GetNext()
		end
	end
end
