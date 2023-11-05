--热炎异种垂钓中
function c33332265.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33332265,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c33332265.sptg1)
	e2:SetOperation(c33332265.spop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33332265,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c33332265.spcon2)
	e3:SetTarget(c33332265.sptg2)
	e3:SetOperation(c33332265.spop2)
	c:RegisterEffect(e3)
end
function c33332265.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33332258,0xa552,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_FIRE) end
	local dis=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0xe000e0)
	Duel.SetTargetParam(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(33332265,1))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(33332265,1))
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33332265.spop1(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33332258,0xa552,TYPES_TOKEN_MONSTER,0,0,1,RACE_AQUA,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,33332258)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c33332265.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,33332258)
end
function c33332265.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c33332265.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsRace(RACE_FISH) and tc:IsAttribute(ATTRIBUTE_FIRE)
		and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,33332258)
		and Duel.SelectYesNo(1-tp,aux.Stringid(33332265,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dc=Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,33332258):GetFirst()
		local seq=dc:GetSequence()
		if Duel.Destroy(dc,REASON_EFFECT)>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,1<<seq)
		end
	else
		Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
	end
end