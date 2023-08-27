local m=82207018
local cm=_G["c"..m]
cm.name="紫悠悠"
function cm.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit()	
	aux.AddFusionProcCodeFun(c,27288416,cm.matfilter,1,true,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e1:SetValue(cm.splimit)  
	c:RegisterEffect(e1) 
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetCountLimit(1)  
	e2:SetTarget(cm.destg)  
	e2:SetOperation(cm.desop)  
	c:RegisterEffect(e2)  
	--indes  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)  
	local e4=e3:Clone()  
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetCode(aux.indoval)
	c:RegisterEffect(e4)  
	local e5=e3:Clone()   
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)  
	c:RegisterEffect(e5)
end
function cm.matfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.splimit(e,se,sp,st)  
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return false end  
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)  
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)  
	g1:Merge(g2)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)  
	if tg:GetCount()>0 then 
		Duel.Destroy(tg,REASON_EFFECT)  
	end  
end  