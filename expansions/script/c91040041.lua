--俱利伽罗剑\
local m=91040041
local cm=c91040041
function c91040041.initial_effect(c)
	aux.AddCodeList(c,35405755)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetValue(cm.fuslimit)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.target)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(cm.value)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.spcon1)
	e6:SetCost(cm.cost)
	e6:SetTarget(cm.sptg1)
	e6:SetOperation(cm.spop1)
	c:RegisterEffect(e6)
end
function cm.target(e,c)
	return aux.IsCodeListed(c,35405755) or c:IsCode(35405755) 
end
function cm.fuslimit(e,c,sumtype)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer()) and sumtype==SUMMON_TYPE_FUSION 
end
function cm.value(e,c,tp,sump)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer())
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return   rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function cm.thfilter3(c)
	return aux.IsCodeListed(c,35405755)  and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.thfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_MZONE)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil,tp)
			local rc=tg:GetFirst()
			if Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(rc)
				e1:SetCountLimit(1)
				e1:SetCondition(cm.retcon)
				e1:SetOperation(cm.retop)
				Duel.RegisterEffect(e1,tp)
			end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end


