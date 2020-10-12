--红·瑟谣浮收藏-刺痕
function c79029338.initial_effect(c)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029038)
	c:RegisterEffect(e2)	 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,79029338)
	e1:SetCost(c79029338.dacost)
	e1:SetTarget(c79029338.datg)
	e1:SetOperation(c79029338.daop)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,09029338)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c79029338.rhtg)
	e1:SetOperation(c79029338.rhop)
	c:RegisterEffect(e1)   
end
function c79029338.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c79029338.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCurrentChain()
	if chk==0 then return ct>1 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*800)
end
function c79029338.daop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	Debug.Message("红的眼中——倒映出你的死")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029338,0))
end
function c79029338.rhfil(c)
	return c:IsSetCard(0xa904) and c:IsAbleToHand()
end
function c79029338.rhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCurrentChain()
	if chk==0 then return ct>1 and Duel.IsExistingMatchingCard(c79029338.rhfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Debug.Message("搅乱他们。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029338,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029338.rhfil,tp,LOCATION_GRAVE,0,1,ct,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_GRAVE)
end
function c79029338.rhop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end











