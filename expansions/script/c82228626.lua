local m=82228626
local cm=_G["c"..m]
cm.name="孑影之巡礼"
function cm.initial_effect(c)
	--activate  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_ACTIVATE)  
	e0:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e0)  
	--atk  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetRange(LOCATION_SZONE)  
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e1:SetTarget(cm.atktg)  
	e1:SetValue(cm.atkval)  
	c:RegisterEffect(e1)  
	--spsummon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_POSITION)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_SZONE)   
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.poscost)
	e2:SetTarget(cm.postg)  
	e2:SetOperation(cm.posop)  
	c:RegisterEffect(e2)  
end
function cm.atktg(e,c)  
	return c:IsFaceup() and c:IsSetCard(0x3299)
end  
function cm.atkfilter(c)  
	return c:IsSetCard(0x3299) and c:IsType(TYPE_MONSTER)  
end  
function cm.atkval(e,c)  
	return Duel.GetMatchingGroup(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil):GetCount()*100  
end  
function cm.filter(c)  
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()  
end  
function cm.rfilter(c,tp)  
	return c:IsSetCard(0x3299) and c:IsType(TYPE_LINK) 
end  
function cm.poscost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.rfilter,1,nil,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)  
	local g=Duel.SelectReleaseGroup(tp,cm.rfilter,1,1,nil,tp)  
	Duel.Release(g,REASON_COST)  
end  
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) end  
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)  
end  
function cm.posop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)  
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE) 
end 