--不死组·蓬莱山辉夜
function c9950033.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9950033)
	e1:SetCondition(c9950033.sprcon)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9950033)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9950033.sptg1)
	e1:SetOperation(c9950033.spop1)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c9950033.efcon)
	e2:SetOperation(c9950033.efop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950033.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950033.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950033,0))
end
function c9950033.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xba1,0xba2)
end
function c9950033.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c9950033.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9950033.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xba1,0xba2)
end
function c9950033.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9950033.filter(chkc) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if ft<-1 then return false end
		return e:GetHandler():IsCanBeSpecialSummoned(e,1,tp,false,false)
			and Duel.IsExistingTarget(c9950033.filter,tp,LOCATION_ONFIELD,0,2,nil)
			and (ft>0 or Duel.IsExistingTarget(c9950033.filter,tp,LOCATION_MZONE,0,-ft+1,nil))
	end
	local g=nil
	if ft~=0 then
		local loc=LOCATION_ONFIELD
		if ft<0 then loc=LOCATION_MZONE end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectTarget(tp,c9950033.filter,tp,loc,0,2,2,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectTarget(tp,c9950033.filter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectTarget(tp,c9950033.filter,tp,LOCATION_ONFIELD,0,1,1,g:GetFirst())
		g:Merge(g2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9950033.spop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
function c9950033.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c9950033.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(9950033,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9950033.drcon)
	e1:SetTarget(c9950033.drtg)
	e1:SetOperation(c9950033.drop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c9950033.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9950033.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9950033.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
