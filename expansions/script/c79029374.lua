--哥伦比亚·特种干员-卡夫卡
function c79029374.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79029374)
	e1:SetTarget(c79029374.sptg)
	e1:SetOperation(c79029374.spop)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,09029374)
	e1:SetCondition(c79029374.discon)
	e1:SetCost(c79029374.discost)
	e1:SetTarget(c79029374.distg)
	e1:SetOperation(c79029374.disop)
	c:RegisterEffect(e1)
end
function c79029374.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end
function c79029374.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	Debug.Message("哼哼~")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029374,0))
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029374.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c79029374.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa900) and c:IsLocation(LOCATION_EXTRA)
end
function c79029374.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and (re:GetHandler():IsLocation(LOCATION_HAND) or re:GetHandler():IsLocation(LOCATION_GRAVE))
end
function c79029374.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c79029374.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c79029374.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Debug.Message("卡夫卡知道你在害怕。颤抖的枯枝们。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029374,1))
	Duel.NegateEffect(ev)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c79029374.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029374.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0xa900) and (re:GetHandler():IsType(TYPE_MONSTER))
end




