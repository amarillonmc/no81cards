--天下布武·帝都组
function c9950067.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3ba5),aux.FilterBoolFunction(Card.IsFusionSetCard,0x5ba5),true)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9950067+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c9950067.spcon)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,9950067)
	e3:SetCost(c9950067.drcost)
	e3:SetTarget(c9950067.drtg)
	e3:SetOperation(c9950067.drop)
	c:RegisterEffect(e3)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950067,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,99500670)
	e3:SetCost(c9950067.spcost)
	e3:SetTarget(c9950067.sptg)
	e3:SetOperation(c9950067.spop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950067.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
c9950067.material_setcode=0x3ba5
function c9950067.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950067,1))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950067,2))
end
function c9950067.spcon(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ((Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(tp,LOCATION_MZONE,nil)) or(Duel.GetLP(1-tp)>Duel.GetLP(tp)))
end
function c9950067.cfilter2(c)
	return c:IsSetCard(0xba5) and c:IsAbleToGraveAsCost()
end
function c9950067.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950067.cfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9950067.cfilter2,1,1,REASON_COST,nil)
end
function c9950067.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9950067.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9950067.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba5) and c:IsLevelBelow(6) and not c:IsCode(9950067) and c:IsAbleToRemoveAsCost()
end
function c9950067.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950067.cfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950067.cfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950067.spfilter(c,e,tp)
	return c:IsCode(9950074) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9950067.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c9950067.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950067.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950067.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
