--极光仙子
local m=82209054
local cm=_G["c"..m]
function cm.initial_effect(c) 
	--indes  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e0:SetValue(cm.indlimit)  
	c:RegisterEffect(e0)   
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)   
end  
function cm.indlimit(e,c)  
	return c:IsAttribute(ATTRIBUTE_DARK)
end  
function cm.filter(c,e,tp)  
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if ft<=0 then return end  
	if ft>2 then ft=2 end  
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,ft,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
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