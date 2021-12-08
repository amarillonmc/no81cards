--超 幻 海 袭  古 机
function c53705007.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(c53705007.defval)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53705007,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	e2:SetCondition(c53705007.spcon)
	e2:SetOperation(c53705007.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(53705007,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c53705007.condition)
	e3:SetTarget(c53705007.target)
	e3:SetOperation(c53705007.operation)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53705007,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c53705007.drcon)
	e4:SetTarget(c53705007.drtg)
	e4:SetOperation(c53705007.drop)
	c:RegisterEffect(e4)
	--??
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e00:SetCode(EVENT_DESTROYED)
	e00:SetProperty(EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetCondition(c53705007.ddcon)
	e00:SetOperation(c53705007.ctop)
	c:RegisterEffect(e00)
end
function c53705007.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetPreviousControler()==tp
end
function c53705007.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(53705018,RESET_EVENT+RESETS_STANDARD,0,0)
end
function c53705007.defval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsPublic,c:GetControler(),LOCATION_HAND,0,nil)*300
end
function c53705007.cfilter(c,tp)
	return c:IsSetCard(0x3534) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c53705007.cfilter1,tp,LOCATION_HAND,0,1,c) and c:IsPublic() and not c:IsType(TYPE_TUNER)
end
function c53705007.cfilter1(c)
	return c:IsSetCard(0x3534) and c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToDeckAsCost() and c:IsPublic()
end
function c53705007.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c53705007.cfilter,tp,LOCATION_HAND,0,1,c,tp) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c53705007.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c53705007.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c53705007.cfilter1,tp,LOCATION_HAND,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c53705007.filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToDeckAsCost()
end
function c53705007.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function c53705007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c53705007.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if #g>0 and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and tc:IsPreviousSetCard(0x3534) and tc:IsPreviousPosition(POS_FACEUP) then 
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c53705007.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c53705007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c53705007.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
