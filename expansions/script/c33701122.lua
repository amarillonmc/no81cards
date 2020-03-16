--盖亚意识 篝
function c33701122.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c33701122.mfilter,1,1)
	c:EnableReviveLimit()
  --link summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701122,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33701122)
	e1:SetCondition(c33701122.condition)
	e1:SetTarget(c33701122.target)
	e1:SetOperation(c33701122.operation)
	c:RegisterEffect(e1)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701122,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,337011220)
	e1:SetCondition(c33701122.drcon)
	e1:SetTarget(c33701122.drtg)
	e1:SetOperation(c33701122.drop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c33701122.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c33701122.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701122,2))
end
function c33701122.mfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_TUNER)
end
function c33701122.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c33701122.tgfilter(c,tp,ec)
	local mg=Group.FromCards(ec,c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL) and Duel.IsExistingMatchingCard(c33701122.lfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c33701122.lfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsCode(33701122) and c:IsLinkSummonable(mg,nil,2,2)
end
function c33701122.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c33701122.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33701122.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33701122.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp)
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e) then
		local mg=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c33701122.lfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local lc=g:GetFirst()
		if lc then
			Duel.LinkSummon(tp,lc,mg,nil,2,2)
		end
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701122,2))
end
function c33701122.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c33701122.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33701122.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end