--星锻极诣 圣剑使阿尔托莉雅
function c22022900.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff1))
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff1))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--race
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff1))
	e4:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e4)
	--race
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_ADD_ATTRIBUTE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff1))
	e5:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22022900,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1,22022900)
	e6:SetTarget(c22022900.sptg)
	e6:SetOperation(c22022900.spop)
	c:RegisterEffect(e6)
	--tograve
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22022900,1))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,22022900)
	e7:SetCondition(c22022900.effcon)
	e7:SetTarget(c22022900.tgtg)
	e7:SetOperation(c22022900.tgop)
	c:RegisterEffect(e7)
	--spsummon
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(22022900,2))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCountLimit(1,22022900)
	e8:SetCondition(c22022900.erecon)
	e8:SetCost(c22022900.erecost)
	e8:SetTarget(c22022900.sptg)
	e8:SetOperation(c22022900.spop)
	c:RegisterEffect(e8)
end
function c22022900.espfilter(c,e,tp)
	return c:IsSetCard(0x6ff1) and c:IsType(TYPE_SYNCHRO) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22022900.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022900.espfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22022900.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22022900.espfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(22022900,3))
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22022900.tgfilter(c)
	return c:IsSetCard(0x6ff1) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToGrave()
end
function c22022900.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022900.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c22022900.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22022900.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		if tc:IsRace(RACE_WARRIOR) and g1:GetCount()>0 then
			Duel.SelectOption(tp,aux.Stringid(22022900,4))
			Duel.SendtoGrave(g1,REASON_RULE) end
		if tc:IsRace(RACE_SPELLCASTER) then
			Duel.SelectOption(tp,aux.Stringid(22022900,5))
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_FIELD)
		   e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		   e1:SetTargetRange(0,1)
		   e1:SetValue(c22022900.aclimit)
		   e1:SetReset(RESET_PHASE+PHASE_END)
		   Duel.RegisterEffect(e1,tp)
		end
	end
end
function c22022900.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c22022900.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22022900.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22022900.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end