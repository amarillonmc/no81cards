--fate·埃尔梅罗二世
function c9950551.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xba5),3)
	--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950551.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950551,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9950551)
	e1:SetCondition(c9950551.spcon)
	e1:SetCost(c9950551.spcost)
	e1:SetTarget(c9950551.sptg)
	e1:SetOperation(c9950551.spop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	e2:SetCondition(c9950551.effcon)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(0,1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(4)
	e4:SetCondition(c9950551.actcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetLabel(6)
	e5:SetCondition(c9950551.effcon)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(9950551,ACTIVITY_SPSUMMON,c9950551.counterfilter)
end
function c9950551.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950551,0))
end
function c9950551.counterfilter(c)
	return c:IsSetCard(0xba5)
end
function c9950551.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9950551.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9950551,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9950551.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9950551.splimit(e,c)
	return not c:IsSetCard(0xba5)
end
function c9950551.spfilter(c,e,tp,zone)
	return c:IsSetCard(0xba5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c9950551.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	local g=Duel.GetMatchingGroup(c9950551.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ft>1 and g:GetClassCount(Card.GetLevel)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c9950551.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	local g=Duel.GetMatchingGroup(c9950551.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone)
	if c:IsRelateToEffect(e) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1 and g:GetClassCount(Card.GetLevel)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dlvcheck,false,2,2)
		if sg and sg:GetCount()==2 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
		end
	end
end
function c9950551.effilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950551.effcon(e)
	return Duel.GetMatchingGroupCount(c9950551.effilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)>=e:GetLabel()
end
function c9950551.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return c9950551.effcon(e) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end