--猩 红 庭 院 的 子 爵
local m=22348268
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,2,nil,nil,99)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348268,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c22348268.spcost)
	e1:SetTarget(c22348268.sptg)
	e1:SetOperation(c22348268.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c22348268.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348268,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetCost(c22348268.spcost1)
	e3:SetTarget(c22348268.sptg1)
	e3:SetOperation(c22348268.spop1)
	c:RegisterEffect(e3)
	
end

function c22348268.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsPlayerCanSpecialSummonMonster(tp,22348269,nil,TYPES_TOKEN_MONSTER,0,300,1,RACE_ZOMBIE,ATTRIBUTE_DARK) and ct>0 end
	local spct=0
	if ct>3 then ct=3 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) then
		spct=e:GetHandler():RemoveOverlayCard(tp,1,ct,REASON_COST)
	end
	e:SetLabel(spct)
end
function c22348268.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local spct=e:GetLabel()
	if chk==0 then return c:IsCanTurnSet() and Duel.IsPlayerCanSpecialSummonMonster(tp,22348269,nil,TYPES_TOKEN_MONSTER,0,300,1,RACE_ZOMBIE,ATTRIBUTE_DARK) and ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c22348268.spop(e,tp,eg,ep,ev,re,r,rp)
	local spct=e:GetLabel()
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<spct then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,22348269,nil,TYPES_TOKEN_MONSTER,0,300,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		if spct==1 then
		local token1=Duel.CreateToken(tp,22348269)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonComplete()
		elseif spct==2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local token1=Duel.CreateToken(tp,22348269)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local token2=Duel.CreateToken(tp,22348270)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonComplete()
		elseif spct==3 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local token1=Duel.CreateToken(tp,22348269)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local token2=Duel.CreateToken(tp,22348270)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local token3=Duel.CreateToken(tp,22348271)
		Duel.SpecialSummonStep(token3,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonComplete() end
	end
end
function c22348268.indcon(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function c22348268.costfilter(c,tp)
	return c:IsCode(22348269) and Duel.GetMZoneCount(tp,c)>0
end
function c22348268.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22348268.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c22348268.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22348268.spfilter1(c,e,tp)
	return c:IsSetCard(0xa70a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348268.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22348268.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22348268.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22348268.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22348268.smfilter(c)
	return c:IsSummonable(true,nil)
end
function c22348268.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(c22348268.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22348268,2)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			Duel.BreakEffect()
	local g=Duel.SelectMatchingCard(tp,c22348268.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	end
end




