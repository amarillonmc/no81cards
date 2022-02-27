local m=53799212
local cm=_G["c"..m]
cm.name="酒饮"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.fselect(g,c)
	return g:IsContains(c)
end
function cm.con(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	return g:CheckSubGroup(cm.fselect,2,#g,c) and Duel.GetMZoneCount(tp)>1 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local fg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=fg:SelectSubGroup(tp,cm.fselect,false,2,math.min(#fg,Duel.GetMZoneCount(tp),(Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)+1)),c)
	sg:Merge(g)
end
