local m=82206092
local cm=_G["c"..m]
cm.name="六界神王"
function cm.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x29b),2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL) 
	--spsummon condition  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)  
	c:RegisterEffect(e1)
	--negate  
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_CHAINING)  
	e3:SetCountLimit(1)  
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCondition(cm.discon)  
	e3:SetCost(cm.discost)  
	e3:SetTarget(cm.distg)  
	e3:SetOperation(cm.disop)  
	c:RegisterEffect(e3)   
	--spsummon  
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e4:SetType(EFFECT_TYPE_QUICK_O)  
	e4:SetCode(EVENT_FREE_CHAIN)  
	e4:SetHintTiming(0,TIMING_END_PHASE)  
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.spcon)
	e4:SetCost(cm.spcost)  
	e4:SetTarget(cm.sptg)  
	e4:SetOperation(cm.spop)  
	c:RegisterEffect(e4)  
end  
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)  
	if bit.band(loc,LOCATION_ONFIELD)==0 then return false end
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end  
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end  
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)  
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Destroy(eg,REASON_EFFECT)  
	end  
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()~=tp  
end 
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end  
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x29b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)   
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end  
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)  
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end  
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
end  