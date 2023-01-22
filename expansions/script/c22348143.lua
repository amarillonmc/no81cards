--地 狱 恶 魔 的 CEO 路 西 法
local m=22348143
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),8,2,c22348143.ovfilter,aux.Stringid(22348143,0),99,c22348143.xyzop)
	c:EnableReviveLimit()
	--field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_ENVIRONMENT)
	e1:SetValue(94585852)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(22348143,1))  
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_CONTROL)  
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCost(c22348143.ccost)  
	e2:SetTarget(c22348143.cttg)  
	e2:SetOperation(c22348143.ctop) 
	c:RegisterEffect(e2)
	--Remove 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348143,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,22348143)
	e3:SetCost(c22348143.cost)  
	e3:SetCondition(c22348143.condition)
	e3:SetTarget(c22348143.target)
	e3:SetOperation(c22348143.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c22348143.regop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	c22348143.onfield_effect=e2
	c22348143.SetCard_diyuemo=true
	
end
function c22348143.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x45) and c:IsLevel(8)
end
function c22348143.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,22348143)==0 end
	Duel.RegisterFlagEffect(tp,22348143,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c22348143.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c22348143.cfilter(c)
	return c.SetCard_diyuemo and c:IsLocation(LOCATION_REMOVED)
end
function c22348143.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=e:GetLabel()
	local g=Duel.GetDecktopGroup(tp,2*ct1)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local g2=Duel.GetOperatedGroup()
	local ct=g2:FilterCount(c22348143.cfilter,nil)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function c22348143.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	e:GetLabelObject():SetLabel(ct)
end
function c22348143.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function c22348143.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2*ct)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2*ct,tp,LOCATION_DECK)
end 
function c22348143.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c22348143.atkfilter(c)
	return c:IsFaceup() and not c:IsAttack(0) and c:IsControlerCanBeChanged()
end
function c22348143.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348143.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c22348143.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348143.atkfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local tg=g:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc and Duel.GetControl(tc,tp) then
		local d=tc:GetAttack()
			Duel.Recover(tp,d,REASON_EFFECT)
		end
	end
end



