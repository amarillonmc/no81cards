--闪光No.39 希望皇 霍普·彼岸
local m=11561050
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),6,2,c11561050.ovfilter,aux.Stringid(11561050,0),3,c11561050.xyzop)
	c:EnableReviveLimit()
	--imm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11561050)
	e1:SetCondition(c11561050.imcon)
	e1:SetCost(c11561050.imcost)
	e1:SetOperation(c11561050.imop)
	c:RegisterEffect(e1)
	--Atk Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetCondition(c11561050.atkcon)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e3:SetCondition(c11561050.spcon)
	e3:SetCost(c11561050.imcost)
	e3:SetTarget(c11561050.spctg)
	e3:SetOperation(c11561050.spcop)
	c:RegisterEffect(e3)

	
end
aux.xyz_number[11561050]=39


function c11561050.sovfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanOverlay() and c:IsFaceup()
end
function c11561050.sovfilter2(c,e,tp)
	return c:IsSetCard(0x107f) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11561050.spctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c11561050.sovfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c11561050.sovfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c11561050.sovfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c11561050.sovfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function c11561050.spcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local scc=g:GetFirst()
	local spc=g:GetNext()
	local tc
	if not spc:IsRelateToEffect(e) or not scc:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(spc,0,tp,tp,false,false,POS_FACEUP)>0 and not scc:IsImmuneToEffect(e) then
		local og=scc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(spc,scc)
			Duel.BreakEffect()
			local rec=math.ceil(spc:GetAttack()/2)
			Duel.Recover(tp,rec,REASON_EFFECT)
	end
end
function c11561050.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x107f) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c11561050.spcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x107f)
end
function c11561050.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c11561050.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f)
end
function c11561050.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561050.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c11561050.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c11561050.imcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c11561050.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11561050.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c11561050.imop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	local tc=g1:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		e1:SetValue(c11561050.efilter)
		tc:RegisterEffect(e1)
		tc=g1:GetNext()
	end
end
function c11561050.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end