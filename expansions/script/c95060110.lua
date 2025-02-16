local s, id = GetID()

function s.initial_effect(c)
	-- 同调召唤条件：同调调整 + 闡·广成子（假设广成子卡密为9560050）
	c:EnableReviveLimit()   
	aux.AddSynchroProcedure(
		c,
		aux.FilterBoolFunction(Card.IsType, TYPE_SYNCHRO),  -- 调整必须为同调怪兽
		aux.FilterBoolFunction(Card.IsCode, 95060050),	 -- 非调整必须为「闡·广成子」
		1, 1
	)
	
	
	-- 效果①：不会被选为效果对象
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(aux.tgoval)
	c:RegisterEffect(e0)
	
	-- 效果②：无效并除外魔陷/怪兽效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+1) -- 与效果③共享次数
	e1:SetCondition(s.negcon)
--  e1:SetCost(s.cost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	
	-- 效果③：无效召唤/特召并除外
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1) -- 与效果②共享次数
	e2:SetCondition(s.sumcon)
   -- e2:SetCost(s.cost)
	e2:SetTarget(s.sumtg)
	e2:SetOperation(s.sumop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	
	-- 效果④：破坏代破（幻龙族）
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
   -- e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.reptg)
	e5:SetOperation(s.repop)
	c:RegisterEffect(e5)
end

--===== 通用cost（暂时除外自身）=====--
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

--===== 效果②：无效+除外 =====--
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
		and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

--===== 效果③：无效召唤+除外 =====--
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain()==0
end

function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end

function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end

--===== 效果④：破坏代破 =====--
function s.repfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToRemove()
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReason(REASON_EFFECT) 
			and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	return Duel.SelectEffectYesNo(tp,c,96)
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end