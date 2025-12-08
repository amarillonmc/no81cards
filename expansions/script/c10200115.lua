--幻叙·消逝的梦
function c10200115.initial_effect(c)
	-- 不能通召
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c10200115.splimit)
	c:RegisterEffect(e0)
	-- 超级冻结
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200115,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10200115)
	e1:SetTarget(c10200115.distg)
	e1:SetOperation(c10200115.disop)
	c:RegisterEffect(e1)
	-- 代替破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10200115.reptg)
	e2:SetValue(c10200115.repval)
	e2:SetOperation(c10200115.repop)
	c:RegisterEffect(e2)
	-- 全部回收
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200115,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10200115.tdcon)
	e3:SetCost(c10200115.tdcost)
	e3:SetTarget(c10200115.tdtg)
	e3:SetOperation(c10200115.tdop)
	c:RegisterEffect(e3)
end
--
function c10200115.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
-- 1
function c10200115.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c10200115.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200115.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c10200115.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c10200115.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_UNRELEASABLE_SUM)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e6:SetValue(1)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e7:SetValue(1)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e8:SetValue(1)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e8)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e9:SetValue(1)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e9)
		local e10=Effect.CreateEffect(c)
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e10:SetValue(1)
		e10:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e10)
	end
end
-- 2
function c10200115.repfilter(c,tp)
	return c:IsSetCard(0x838) and c:IsLocation(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE) and c:IsAbleToRemove()
end
function c10200115.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return r&REASON_EFFECT~=0
		and eg:IsExists(Card.IsSetCard,1,nil,0x838)
		and eg:IsExists(Card.IsControler,1,nil,tp)
		and Duel.IsExistingMatchingCard(c10200115.repfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,eg) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c10200115.repval(e,c)
	return c:IsSetCard(0x838) and c:IsControler(e:GetHandlerPlayer())
end
function c10200115.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10200115.repfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,eg)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
-- 3
function c10200115.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c10200115.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10200115.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function c10200115.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
