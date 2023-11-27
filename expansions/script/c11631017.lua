--特制药·火药
local m=11631017
local cm=_G["c"..m]
--strings
cm.tezhiyao=true 
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--register
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_ACTIVATE_COST)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)  
	e2:SetTargetRange(1,0)  
	e2:SetTarget(cm.actarget)  
	e2:SetCost(aux.TRUE)  
	e2:SetOperation(cm.costop)  
	c:RegisterEffect(e2)  
end

--activate
function cm.cfilter(c)
	return c.yaojishi and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=LOCATION_SZONE 
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		exc=c
		if c:IsLocation(LOCATION_HAND) and c:IsPublic() then
			loc=LOCATION_ONFIELD
		end
	end
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,loc,loc,1,exc) end
	local loc2=LOCATION_SZONE 
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:GetFlagEffect(m)>0 then
		loc2=LOCATION_ONFIELD
		e:SetLabel(114514)
		c:ResetFlagEffect(m)
	end
	local g=Duel.GetMatchingGroup(nil,tp,loc2,loc2,exc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local loc=LOCATION_SZONE
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		exc=e:GetHandler()
		if e:GetLabel()==114514 then
			loc=LOCATION_ONFIELD
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,loc,loc,1,1,exc)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end  

--register
function cm.actarget(e,te,tp)  
	local tc=te:GetHandler()
	return tc==e:GetHandler() and tc:IsLocation(LOCATION_HAND) and tc:IsPublic()
end  
function cm.costop(e,tp,eg,ep,ev,re,r,rp) 
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1) 
end  
