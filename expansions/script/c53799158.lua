local m=53799158
local cm=_G["c"..m]
cm.name=""
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spfilter(c,tp)
	return c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(1-tp,c,tp)>1-math.floor(Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)/5)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,0,LOCATION_MZONE,1,nil,tp)
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=5
end
function cm.fselect(g,tp)
	return Duel.GetMZoneCount(1-tp,g,tp)>1-#g
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,0,LOCATION_MZONE,nil,tp)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,math.floor(Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)/5),tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
