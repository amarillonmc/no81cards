--银河时空龙
local m=22348411
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348411,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22348411)
	e2:SetCost(c22348411.spcost)
	e2:SetTarget(c22348411.sptg)
	e2:SetOperation(c22348411.spop)
	c:RegisterEffect(e2)
	--level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348411,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,22349411)
	e3:SetCondition(c22348411.lvcon)
	e3:SetTarget(c22348411.lvtg)
	e3:SetOperation(c22348411.lvop)
	c:RegisterEffect(e3)

	
end
function c22348411.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348411.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(4,8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348411.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348411.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c22348411.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348411.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348411.cfilter(c,tp)
	return c:IsControler(tp) and c:IsRace(RACE_DRAGON) and c:IsLevelAbove(1)
end
function c22348411.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348411.cfilter,1,nil,tp)
end
function c22348411.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c22348411.cfilter,nil,tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.IsInGroup(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(aux.IsInGroup,tp,LOCATION_MZONE,0,1,nil,g) end
	local sg
	if g:GetCount()==1 then
		sg=g:Clone()
		Duel.SetTargetCard(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		sg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_MZONE,0,1,1,nil,g)
	end
end
function c22348411.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv
		if tc:GetLevel()==4 then lv=8
		elseif tc:GetLevel()==8 then lv=4
		else lv=Duel.AnnounceNumber(tp,4,8) end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
