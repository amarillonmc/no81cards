--奇妙物语 滚滚胖球
function c10128006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c10128006.target)
	e1:SetOperation(c10128006.activate)
	c:RegisterEffect(e1)  
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10128006,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c10128006.tdtg)
	e2:SetOperation(c10128006.tdop)
	c:RegisterEffect(e2) 
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)  
end
function c10128006.tdfilter(c)
	return bit.band(c:GetType(),0x10002)==0x10002 and c:IsAbleToDeck()
end
function c10128006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10128006.tdfilter,tp,LOCATION_GRAVE,0,2,nil) and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c10128006.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,LOCATION_GRAVE)
end
function c10128006.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
	   Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c10128006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,0,tp,LOCATION_ONFIELD+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c10128006.rfilter(c,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 or (ft==0 and (not c:IsLocation(LOCATION_MZONE) or c:GetSequence()>4)) then return false end
	return c:IsSetCard(0x6336) and c:IsType(TYPE_SPELL) and c:IsReleasableByEffect() and Duel.IsExistingMatchingCard(c10128006.spfilter,tp,LOCATION_DECK,0,1,nil,tp,c:GetCode())
end
function c10128006.spfilter(c,tp,code)
	return c:IsCode(code) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x6336,0x21,0,0,1,RACE_ZOMBIE,ATTRIBUTE_EARTH)
end
function c10128006.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(c10128006.rfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,c,tp)
	if rg:GetCount()<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10128006,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rc=rg:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoGrave(rc,REASON_EFFECT+REASON_RELEASE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10128006.spfilter,tp,LOCATION_DECK,0,1,1,nil,tp,rc:GetCode()):GetFirst()
	tc:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_EARTH,RACE_ZOMBIE,1,0,0)
	Duel.SpecialSummonStep(tc,1,tp,tp,true,false,POS_FACEUP)
	--tc:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
end