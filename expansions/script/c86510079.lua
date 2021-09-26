--白蛇神使
local m=86510079
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,4)
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.matval)
	c:RegisterEffect(e1)
	--chair king
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetOperation(cm.sumsuc)  
	c:RegisterEffect(e2)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.remcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetValue(0x2f)
	c:RegisterEffect(e2)
end
function cm.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsLinkType(TYPE_EFFECT)
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsControler,2,nil,1-tp)
end

function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsSummonType(SUMMON_TYPE_LINK) then return end 
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(0,1) 
	e1:SetValue(cm.aclimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_DISABLE)  
	e2:SetTargetRange(0,LOCATION_ONFIELD)  
	e2:SetTarget(cm.disable)  
	e2:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e2,tp)  
end
function cm.aclimit(e,re,tp)  
	return re:GetHandler():IsOnField() and e:GetHandler()~=re:GetHandler()  
end  
function cm.disable(e,c)  
	return c~=e:GetHandler() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))  
end 
function cm.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
			if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e2:SetCountLimit(1)
				e2:SetLabel(Duel.GetTurnCount())
				e2:SetLabelObject(c)
				e2:SetCondition(cm.retcon)
				e2:SetOperation(cm.retop)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e2,tp)
			end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel()
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.spfilter(c,att)
	return c:IsAbleToRemove() and c:IsAttribute(att)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttribute()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetAttribute())
	if g:GetCount()>0 then
	   Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end