local m=53799048
local cm=_G["c"..m]
cm.name="台风魔女甜点师"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cm.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and g:GetClassCount(Card.GetAttribute)==#g
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_REMOVED,0,nil)
	return rg:CheckSubGroup(cm.fselect,2,2,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local sg=rg:SelectSubGroup(tp,cm.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
	g:DeleteGroup()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.rmlimit)
		e1:SetLabel(tc:GetOriginalAttribute())
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		tc=g:GetNext()
	end
end
function cm.rmlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetOriginalAttribute()==e:GetLabel() and not c:IsLocation(LOCATION_ONFIELD)
end
