local m=82208128
local cm=_G["c"..m]
cm.name="龙法师 铁拳制裁龙"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m) 
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6299),3,3,true)  
	aux.AddContactFusionProcedure(c,cm.matfilter,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.SendtoDeck,nil,2,REASON_COST)  
	--spsummon condition  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(cm.splimit)  
	c:RegisterEffect(e0) 
	--destroy all  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetTarget(cm.destg)  
	e1:SetOperation(cm.desop)  
	c:RegisterEffect(e1)  
	--act limit  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetTargetRange(0,1) 
	e2:SetCondition(cm.con)
	e2:SetValue(1)  
	c:RegisterEffect(e2)  
end
function cm.matfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.splimit(e,se,sp,st)  
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)  
	if g:GetCount()>0 then  
		Duel.Destroy(g,REASON_EFFECT)  
	end  
end 
function cm.con(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==0x04 or Duel.GetCurrentPhase()==0x100)
end