local m=82206077
local cm=_G["c"..m]
cm.name="邪界幻灵·修罗"
function cm.initial_effect(c) 
	c:SetSPSummonOnce(m)
	--fusion material  
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x29c),2,true)  
	c:EnableReviveLimit()  
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION) 
	e1:SetValue(cm.splimit) 
	c:RegisterEffect(e1)  
	--special summon rule  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_SPSUMMON_PROC)  
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e2:SetRange(LOCATION_EXTRA)  
	e2:SetCondition(cm.spcon)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)
	--banish extra  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_REMOVE)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetCountLimit(1)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCost(cm.excost)  
	e3:SetTarget(cm.extg)  
	e3:SetOperation(cm.exop)  
	c:RegisterEffect(e3)  
	--inactivatable  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetValue(cm.effectfilter)  
	c:RegisterEffect(e4)  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_FIELD)  
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetValue(cm.effectfilter)  
	c:RegisterEffect(e5)  
end
function cm.splimit(e,se,sp,st)  
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
end  
function cm.spfilter1(c,tp,sc)  
	return c:IsSetCard(0x29c) and c:IsAbleToDeckAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,sc)
end  
function cm.spfilter2(c)  
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()  
end  
function cm.spcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp,c) and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_HAND,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)  
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK) 
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
	local g2=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_HAND,0,1,1,nil)  
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
	Duel.Remove(g2,POS_FACEUP,REASON_COST)
end  
function cm.excost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local lp=800
	if Duel.IsPlayerAffectedByEffect(tp,82206075) then lp=400 end
	if chk==0 then return Duel.CheckLPCost(tp,lp) end  
	Duel.PayLPCost(tp,lp)  
end  
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)  
end  
function cm.exop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)  
	Duel.ConfirmCards(tp,g)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,tp)  
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)  
	Duel.ShuffleExtra(1-tp)  
end  
function cm.effectfilter(e,ct)  
	local p=e:GetHandler():GetControler()  
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)  
	return p==tp and te:GetHandler():IsSetCard(0x29c) and bit.band(loc,LOCATION_PZONE)~=0  
end  