--黑暗战士-邪恶迪迦
function c9950678.initial_effect(c)
	 c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c9950678.sprcon)
	e2:SetOperation(c9950678.sprop)
	c:RegisterEffect(e2)
 --cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
  --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950678,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9950678)
	e1:SetCost(c9950678.drcost)
	e1:SetTarget(c9950678.drtg)
	e1:SetOperation(c9950678.drop)
	c:RegisterEffect(e1)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950678,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,99506780)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c9950678.rmtg)
	e3:SetOperation(c9950678.rmop)
	c:RegisterEffect(e3)
--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950678.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950678.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950678,0))
end
function c9950678.sprfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bd1) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c9950678.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950678.sprfilter,tp,LOCATION_REMOVED,0,2,nil)
end
function c9950678.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9950678.sprfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c9950678.drcfilter(c)
	return c:IsSetCard(0x9bd1) and c:IsDiscardable()
end
function c9950678.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950678.drcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9950678.drcfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c9950678.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9950678.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9950678.chkfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsAbleToRemove()
end
function c9950678.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9950678.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c9950678.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) 
			and not Duel.IsExistingMatchingCard(c9950678.chkfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c9950678.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*300)
end
function c9950678.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9950678.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*300,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950678,0))
end