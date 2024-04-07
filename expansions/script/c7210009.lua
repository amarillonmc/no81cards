--归墟噬神 薄伽丘
function c7210009.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,5,c7210009.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7210009,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMING_SPSUMMON+TIMING_SUMMON+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,7210009)
	e1:SetCondition(c7210009.tdcon)
	e1:SetTarget(c7210009.tdtg)
	e1:SetOperation(c7210009.tdop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7210009,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,17210009)
	e2:SetTarget(c7210009.cttg)
	e2:SetOperation(c7210009.ctop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,27210009)
	e3:SetCondition(c7210009.drcon)
	e3:SetTarget(c7210009.drtg)
	e3:SetOperation(c7210009.drop)
	c:RegisterEffect(e3)
end
function c7210009.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6f8)
end
function c7210009.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c7210009.tdfilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x6f8)
end
function c7210009.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7210009.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7210009.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c7210009.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c7210009.mfilter(c,tp)
	local r=LOCATION_REASON_TOFIELD
	if not c:IsControler(c:GetOwner()) then r=LOCATION_REASON_CONTROL end
	return c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and Duel.GetLocationCount(c:GetOwner(),LOCATION_SZONE,tp,r)>0
end
function c7210009.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
	and Duel.IsExistingMatchingCard(c7210009.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
	and Duel.SelectYesNo(tp,aux.Stringid(7210009,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
		local tc=Duel.SelectMatchingCard(tp,c7210009.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		if not tc:IsImmuneToEffect(e)
			and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	end
end
function c7210009.filter(c)
	return c:GetCounter(0)~=0
end
function c7210009.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7210009.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c7210009.ctop(e,tp,eg,ep,ev,re,r,rp)
	--Immune
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(7210009,4))
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e:GetHandler():RegisterEffect(e2)
	--counter
	local sg=Duel.GetMatchingGroup(c7210009.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=sg:GetFirst()
	local count=0
	while tc do
		count=count+tc:GetCounter(0x100e)
		tc:RemoveCounter(tp,0,0,0)
		tc=sg:GetNext()
	end
	if count>0 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_REMOVE_COUNTER+0x100e,e,REASON_EFFECT,tp,tp,count)
	end
end
function c7210009.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x6f8) and re:GetHandler():IsOnField()
end
function c7210009.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c7210009.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
