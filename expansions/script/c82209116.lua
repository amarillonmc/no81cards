--混沌超量 古代魔神 综合征玛琉斯
local m=82209116
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),2,3,cm.ovfilter,aux.Stringid(m,0),3,cm.xyzop)  
	c:EnableReviveLimit()
	--eat
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.eatcon)
	e1:SetCost(cm.eatcost)
	e1:SetTarget(cm.eattg) 
	e1:SetOperation(cm.eatop)  
	c:RegisterEffect(e1)
	--atk&def
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCode(EFFECT_SET_BASE_ATTACK)  
	e2:SetValue(cm.value)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)  
	c:RegisterEffect(e3)  
	--negate  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)  
	e4:SetType(EFFECT_TYPE_QUICK_O)  
	e4:SetCode(EVENT_CHAINING)  
	e4:SetCountLimit(1)  
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCondition(cm.discon)  
	e4:SetCost(cm.discost)  
	e4:SetTarget(cm.distg)  
	e4:SetOperation(cm.disop)  
	c:RegisterEffect(e4)  
end
function cm.cfilter(c)  
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsDiscardable()  
end  
function cm.ovfilter(c)  
	return c:IsFaceup() and c:IsCode(82209115)
end  
function cm.xyzop(e,tp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end  
	Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD)  
end  

--effect 1
function cm.eatcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)  
end  
function cm.eatcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function cm.eatfilter(c,e)  
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end  
function cm.eattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return true end
end  
function cm.eatop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.eatfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,e)
	local tc=g:GetFirst() 
	while tc do
		local og=tc:GetOverlayGroup()  
		if og:GetCount()>0 then  
			Duel.SendtoGrave(og,REASON_RULE)  
		end  
		Duel.Overlay(c,Group.FromCards(tc)) 
		tc=g:GetNext()
	end  
end 

--effect 2
function cm.value(e,c)  
	return c:GetOverlayCount()*1000
end  

--effect 3
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,82209115) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)  
end  
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return re:GetHandler():IsAbleToRemove() and re:GetHandler()~=e:GetHandler() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)  
	end  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)  
	end  
end  