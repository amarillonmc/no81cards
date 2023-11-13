--忆剑 剑心犹铸
local m=77002514
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.rtg)
	e2:SetOperation(cm.rop)
	c:RegisterEffect(e2)
end
--Effect 1
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.f1(c)
	return c:IsFaceup() and c:IsSetCard(0x3eef)
end
function cm.filter(c)
	return cm.f1(c) and c:IsAbleToRemove() 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local b1=not tc:IsImmuneToEffect(e)
		local b2=tc:GetAttack()>0
		local s
		if b1 and b2 then
			s=Duel.SelectOption(1-tp,aux.Stringid(m,1),aux.Stringid(m,2))
		elseif b1 then
			s=Duel.SelectOption(1-tp,aux.Stringid(m,1))
		else
			s=Duel.SelectOption(1-tp,aux.Stringid(m,2))+1
		end
		if s==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(cm.efilter)
			e1:SetOwnerPlayer(tp)
			tc:RegisterEffect(e1)
			local e13=Effect.CreateEffect(e:GetHandler())
			e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e13:SetType(EFFECT_TYPE_SINGLE)
			e13:SetCode(EFFECT_UPDATE_ATTACK)
			e13:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e13:SetValue(500)
			tc:RegisterEffect(e13)
		end
		if s==1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(0,1)
			e1:SetLabel(tc:GetAttack())
			e1:SetTarget(cm.sumlimit)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsAttackBelow(e:GetLabel())
end
--Effect 2
function cm.tgfilter(c)
	return not c:IsCode(m) and c:IsSetCard(0x3eef) and c:IsFaceup()
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_REMOVED)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end
