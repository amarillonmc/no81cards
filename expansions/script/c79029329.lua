--得克萨斯·瑟谣浮收藏-灼荒信使
function c79029329.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,79029017,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),1,1,true,true)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029017)
	c:RegisterEffect(e2)   
	--sp da
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCountLimit(1,79029329)
	e1:SetTarget(c79029329.sdtg)
	e1:SetOperation(c79029329.sdop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetDescription(aux.Stringid(79029329,3))
	e2:SetCountLimit(1,09029329)
	e2:SetCost(c79029329.tgcost)
	e2:SetOperation(c79029329.tgop)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,19029329)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(c79029329.condition)
	e1:SetTarget(c79029329.target)
	e1:SetOperation(c79029329.activate)
	c:RegisterEffect(e1) 
end
function c79029329.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetOverlayGroup(tp,1,0):FilterSelect(tp,Card.IsAbleToGrave,1,99,nil)
	Duel.SetTargetCard(g)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(g:GetCount()*800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),tp,LOCATION_OVERLAY)
end
function c79029329.sdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if Duel.SendtoGrave(g,REASON_EFFECT) then
	Debug.Message("斩尽杀绝。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029329,0))
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	end
end
function c79029329.tgcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.CheckLPCost(tp,3000) end
	Duel.PayLPCost(tp,3000)
end
function c79029329.tgop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("没人能束缚我。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029329,1))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c79029329.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029329.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
	Duel.SetChainLimit(c79029329.chainlm)
	end
end
function c79029329.chainlm(e,rp,tp)
	return tp==rp
end
function c79029329.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c79029329.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029329.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
	Debug.Message("哼，没问题。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029329,2))
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	end
end








