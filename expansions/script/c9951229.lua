--光之国·黑暗战士贝利亚
function c9951229.initial_effect(c)
	 c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951229,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9951229.sprcon)
	e1:SetOperation(c9951229.sprop)
	c:RegisterEffect(e1)
   --damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9951229.regcon)
	e2:SetOperation(c9951229.regop)
	c:RegisterEffect(e2)
 --atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c9951229.atkcon)
	e4:SetTarget(c9951229.atktg)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	--token
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9951229,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,9951229)
	e5:SetCondition(c9951229.spcon)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(c9951229.sptg)
	e5:SetOperation(c9951229.spop)
	c:RegisterEffect(e5)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951229.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951229.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951229,0))
end
function c9951229.sprfilter(c)
	return c:IsSetCard(0x6bd2) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9951229.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951229.sprfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c9951229.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9951229.sprfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9951229.atkcon(e)
	local d=Duel.GetAttackTarget()
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and d and d:IsControler(1-tp)
end
function c9951229.atktg(e,c)
	return c==Duel.GetAttacker() and c:IsSetCard(0x6bd2)
end
function c9951229.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c9951229.spfilter(c,e,tp)
	return c:IsSetCard(0x6bd2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951229.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951229.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9951229.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9951229.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9951229.filter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x6bd2)
end
function c9951229.regcon(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c9951229.filter,1,nil) and 1-tp==rp
end
function c9951229.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetLabelObject(re)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN)
	e1:SetCondition(c9951229.damcon)
	e1:SetOperation(c9951229.damop)
	c:RegisterEffect(e1)
end
function c9951229.damcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c9951229.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9951229)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end