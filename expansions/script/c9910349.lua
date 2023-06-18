--焦土残迹
function c9910349.initial_effect(c)
	aux.AddCodeList(c,9910316,9910624)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9910349+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetTarget(c9910349.target)
	e1:SetOperation(c9910349.activate)
	c:RegisterEffect(e1)
end
function c9910349.filter(c)
	return c:GetSequence()<5
end
function c9910349.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910349.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910349.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910349,0))
	local g=Duel.SelectTarget(tp,c9910349.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsFaceup() and tc:IsCode(9910316,9910624) then
		Duel.SetTargetParam(1)
		e:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	end
end
function c9910349.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local num=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp)
		or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<1 then return end
	local pseq=tc:GetSequence()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	if num==0 then return end
	local zone=0
	if pseq>nseq then pseq,nseq=nseq,pseq end
	for i=pseq,nseq do
		zone=zone|(1<<i)
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if ft>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9910328,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK)
		and Duel.SelectYesNo(tp,aux.Stringid(9910349,1)) then
		Duel.BreakEffect()
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			for i=1,ft do
				local token=Duel.CreateToken(tp,9910328)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP,zone)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
