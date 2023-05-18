local m=82209049
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m) 
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_PZONE,0)
	e0:SetValue(cm.matval)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.setcon)  
	e1:SetTarget(cm.settg)  
	e1:SetOperation(cm.setop)  
	c:RegisterEffect(e1) 
	--cannot battle destroy 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetHintTiming(TIMING_END_PHASE)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCondition(cm.descon)
	e2:SetCost(cm.descost)  
	e2:SetTarget(cm.destg)  
	e2:SetOperation(cm.desop)  
	c:RegisterEffect(e2)  
end
cm.SetCard_01_Kieju=true
function cm.matfilter(c)
	return c:IsAttackAbove(2500) and c:IsType(TYPE_PENDULUM)
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true, true
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end  
function cm.setfilter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsAttackAbove(2500) and c:CheckUniqueOnField(tp) and not c:IsForbidden()  
end  
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end
	if e:GetHandler():GetSequence()>4 then
		e:SetLabel(1)
	end
end  
function cm.setop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e3:SetTargetRange(1,0)  
	e3:SetLabel(cm.getsummoncount(tp))  
	e3:SetTarget(cm.splimit)  
	e3:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e3,tp)  
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)  
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e4:SetTargetRange(1,0)  
	e4:SetLabel(cm.getsummoncount(tp))  
	e4:SetValue(cm.countval)  
	e4:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e4,tp) 
	if e:GetLabel()~=1 then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)  
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then 
			Duel.SetLP(tp,Duel.GetLP(tp)-tc:GetAttack())
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e1:SetCode(EFFECT_DISABLE)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e1)  
			local e2=e1:Clone()  
			e2:SetCode(EFFECT_DISABLE_EFFECT)  
			e2:SetValue(RESET_TURN_SET)  
			tc:RegisterEffect(e2)  
		end
	end
end
function cm.getsummoncount(tp)  
	return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)  
end  
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)  
	return cm.getsummoncount(sump)>e:GetLabel()  
end  
function cm.countval(e,re,tp)  
	if cm.getsummoncount(tp)>e:GetLabel() then return 0 else return 1 end  
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_PZONE,0,1,nil)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsReleasable() end  
	Duel.Release(c,REASON_COST)  
end  
function cm.filter(c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and not c:IsType(TYPE_PENDULUM)
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and cm.filter(chkc) and chkc~=e:GetHandler() end  
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end  