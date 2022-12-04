--开 花 爷 爷 「 小 白 的 灰 烬 」
local m=22348110
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_ATTACK)
	e1:SetCountLimit(1,22348110+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22348110.target)
	e1:SetOperation(c22348110.activate)
	c:RegisterEffect(e1)
	--change effect type
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(22348110)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
end
function c22348110.filter(c,e,tp)
	return (c:IsLevel(4) or c:IsRank(4)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c22348110.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22348110.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22348110.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22348110.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x704)
end
function c22348110.actcon(e)
	return Duel.IsExistingMatchingCard(c22348110.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c22348110.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
