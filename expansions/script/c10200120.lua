--梦幻叙事记「命运」
function c10200120.initial_effect(c)
	c:EnableReviveLimit()
	-- 特召条件
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10200120.con0)
	e2:SetTarget(c10200120.tg0)
	e2:SetOperation(c10200120.op0)
	c:RegisterEffect(e2)
    -- 攻守上升
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c10200120.val1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
    -- 二选一
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10200120,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,10200120)
	e5:SetCondition(c10200120.con2)
	e5:SetTarget(c10200120.tg2)
	e5:SetOperation(c10200120.op2)
	c:RegisterEffect(e5)
    -- 通用效果
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetTarget(c10200120.tg3)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
-- 特召条件
function c10200120.filter0(c)
	return c:IsSetCard(0x838) and c:IsAbleToRemoveAsCost()
end
function c10200120.con0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetMatchingGroup(c10200120.filter0,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_SZONE,0,c):GetClassCount(Card.GetCode)>=6
end
function c10200120.tg0(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if chk==0 then return Duel.GetMatchingGroup(c10200120.filter0,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_SZONE,0,c):GetClassCount(Card.GetCode)>=6 end
	local g=Duel.GetMatchingGroup(c10200120.filter0,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_SZONE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,6,6)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c10200120.op0(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
-- 1
function c10200120.val1(e,c)
	return Duel.GetMatchingGroupCount(nil,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)*100
end
-- 2
function c10200120.con2(e,tp,eg,ep,ev,re,r,rp)
	local b1 = rp==1-tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	local b2 = re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
	if b2 then
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		b2 = tg and tg:IsExists(c10200120.cfilter,1,nil,tp)
	end
	return b1 or b2
end
function c10200120.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c10200120.rmfilter1(c)
	return c:IsAbleToRemove()
end
function c10200120.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end
function c10200120.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==1 then
			return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup()
		else
			return false
		end
	end
	local b1 = rp==1-tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	local b2 = re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
	if b2 then
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		b2 = tg and tg:IsExists(c10200120.cfilter,1,nil,tp)
	end
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(10200120,3),aux.Stringid(10200120,4))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(10200120,3))
	else
		op=Duel.SelectOption(tp,aux.Stringid(10200120,4))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_REMOVE)
		local rc=re:GetHandler()
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,1-tp,LOCATION_HAND+LOCATION_ONFIELD)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,PLAYER_ALL,LOCATION_MZONE)
	end
end
function c10200120.op2(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		re:GetHandler():RegisterFlagEffect(10200120,RESET_CHAIN,0,1)
		Duel.ChangeChainOperation(ev,c10200120.repop1)
	else
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(c10200120.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function c10200120.repop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler()
	Duel.Hint(HINT_CARD,0,10200120)
	local g=Group.CreateGroup()
	if rc and rc:IsAbleToRemove() then
		g:AddCard(rc)
	end
	if Duel.IsExistingMatchingCard(c10200120.rmfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,rc) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(tp,c10200120.rmfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,rc)
		g:Merge(sg)
	end
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
-- 3
function c10200120.tg3(e,c)
	local tc=e:GetHandler()
	return c==tc or c==tc:GetBattleTarget()
end
