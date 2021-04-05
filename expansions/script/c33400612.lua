--星宫六喰 花魁
local m=33400612
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,cm.xyzfilter,8,3)
	c:EnableReviveLimit() 
	 --summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.sumsuc)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.discost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,m+10000)
	e3:SetCondition(cm.setcon)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(cm.setcon2)
	c:RegisterEffect(e4)
end
function cm.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_XYZ) then return end
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.elimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local b2=Duel.GetMatchingGroup(cm.negfilter,tp,0,LOCATION_ONFIELD,nil)
	local nc=b2:GetFirst()
		while nc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e2)
			if nc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				nc:RegisterEffect(e3)
			end
			nc=b2:GetNext()
		end
end
function cm.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.negfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_SPELL,TYPE_TRAP)
end

function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function cm.rmfilter(c)
	return (c:IsType(TYPE_SPELL,TYPE_TRAP) or c:IsLocation(LOCATION_SZONE)) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,22,nil)
	local ts=Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	if c:IsFaceup() then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(ts*300)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end

function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)==0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.setcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)>0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.setfilter(c,tp)
	return c:IsType(TYPE_SPELL,TYPE_TRAP)  and c:IsSetCard(0x340,0x341) and  c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cm.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_REMOVED,0,1,nil,tp) end 
e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3)) 
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if not Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_REMOVED,0,1,nil,tp) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp) 
	  Duel.SSet(tp,g)
	if  Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_REMOVED,0,1,nil,tp) then 
			 if  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
				Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
				 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local g2=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp) 
				 Duel.SSet(tp,g2)
			 end
	end 
end
function cm.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end