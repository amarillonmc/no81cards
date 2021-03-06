local m=31407003
local cm=_G["c"..m]
cm.name="黑洞吻异变龙"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local esp=Effect.CreateEffect(c)
	esp:SetType(EFFECT_TYPE_FIELD)
	esp:SetCode(EFFECT_SPSUMMON_PROC)
	esp:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	esp:SetRange(LOCATION_EXTRA)
	esp:SetValue(SUMMON_TYPE_SYNCHRO)
	esp:SetCondition(cm.sycon)
	esp:SetOperation(cm.syop)
	c:RegisterEffect(esp)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
end
function cm.stfilter1(c,tc)
	return c:IsSynchroType(TYPE_SYNCHRO) and c:IsSynchroType(TYPE_TUNER) and c:IsRace(RACE_DRAGON) and c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc)
end
function cm.stfilter2(c,tc)
	return c:IsSynchroType(TYPE_SYNCHRO) and c:IsSynchroType(TYPE_TUNER) and not c:IsRace(RACE_DRAGON) and c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc)
end
function cm.stfilterg(g,tp,tc,smat)
	if smat then
		g:AddCard(smat)
	end
	local g1=g:Filter(cm.stfilter1,nil,tc)
	local g2=g:Filter(cm.stfilter2,nil,tc)
	local count=g:GetCount()
	return g1:GetCount()==1 and g2:GetCount()==count-1 and g:GetSum(Card.GetLevel)==12 and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.sycon(e,c,smat,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	if smat then
		mg:RemoveCard(smat)
		return mg:CheckSubGroup(cm.stfilterg,2,nil,tp,c,smat)
	else
		return mg:CheckSubGroup(cm.stfilterg,3,nil,tp,c,nil)
	end
end
function cm.syop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	local g=Group.CreateGroup()
	if smat then
		mg:RemoveCard(smat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,2,nil,tp,c,smat))
		g:AddCard(smat)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,3,nil,tp,c,nil))
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function cm.efilter(e,te)
	return (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP)) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end