-- 绮奏·缄星绝唱 赫罗绯尔忒
local s,id=GetID()
function s.initial_effect(c)

	-- 包含机械族融合怪兽的属性不同的机械族怪兽×4
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,s.mfilter1,s.mfilter2,3,true,true)

	-- 只要这张卡在怪兽区域存在，和这张卡相同纵列的没有使用的区域不能使用
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(s.disval)
	c:RegisterEffect(e1)
	
	-- 双方回合1次，从自己的手卡·场上·墓地把1只机械族怪兽除外，以场上1张表侧表示卡为对象才能发动。作为对象的卡的效果无效并破坏，直到下个回合的结束时，那张卡存在过的区域不能使用，这次决斗中自己不能为让「绮奏·缄星绝唱 赫罗绯尔忒」的效果发动而把相同属性的怪兽除外
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	
	-- 融合召唤的这张卡因对方从场上离开的场合才能发动，这个回合对方不能把场上发动的效果发动
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.lmtcon)
	e3:SetOperation(s.lmtop)
	c:RegisterEffect(e3)
end

-- 包含机械族融合怪兽的属性不同的机械族怪兽×4
function s.mfilter1(c)
	return c:IsRace(RACE_MACHINE) and c:IsFusionType(TYPE_FUSION)
end

function s.mfilter2(c,fc,sub,mg,sg)
	return c:IsRace(RACE_MACHINE) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end

-- 只要这张卡在怪兽区域存在，和这张卡相同纵列的没有使用的区域不能使用
function s.disval(e)
	local c=e:GetHandler()
	return c:GetColumnZone(LOCATION_ONFIELD,0)
end

-- 双方回合1次，从自己的手卡·场上·墓地把1只机械族怪兽除外，以场上1张表侧表示卡为对象才能发动。作为对象的卡的效果无效并破坏，直到下个回合的结束时，那张卡存在过的区域不能使用，这次决斗中自己不能为让「绮奏·缄星绝唱 赫罗绯尔忒」的效果发动而把相同属性的怪兽除外
function s.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND+LOCATION_GRAVE))
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function s.nbfilter(c)
	return c:IsFaceup() and aux.NegateAnyFilter(c) and c:IsDestructable()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and s.nbfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.nbfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.nbfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
		local c=e:GetHandler()
		local val=aux.SequenceToGlobal(tc:GetControler(),tc:GetLocation(),tc:GetSequence())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local ef=Effect.CreateEffect(c)
			ef:SetType(EFFECT_TYPE_FIELD)
			ef:SetCode(EFFECT_DISABLE_FIELD)
			ef:SetValue(val)
			ef:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(ef,tp)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.rmlimit)
	e1:SetLabel(e:GetLabel())
	Duel.RegisterEffect(e1,tp)
end

function s.rmlimit(e,c,tp,r,re)
	return c:IsAttribute(e:GetLabel()) and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsCode(id) and r==REASON_COST
end

-- 融合召唤的这张卡因对方从场上离开的场合才能发动，这个回合对方不能把场上发动的效果发动
function s.lmtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end

function s.lmtop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
