--蒸汽朋克·终算神机龙
local s,id,o=GetID()
function s.initial_effect(c)
	
	-- 从额外卡组特殊召唤的念动力族怪兽3只
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,3)
	
	-- 这张卡不用连接召唤不能特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	
	-- 1回合1次，让自己的墓地·除外状态的1张「蒸汽朋克」卡回到卡组·额外卡组才能发动，对方场上1张卡回到卡组
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.cost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	
	-- 对方发动的效果的处理时，可以把场上的这张卡直到结束阶段除外，那个场合，那个效果无效化
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.negcon)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
end

-- 从额外卡组特殊召唤的念动力族怪兽3只
function s.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsRace(RACE_PSYCHO)
end

-- 1回合1次，让自己的墓地·除外状态的1张「蒸汽朋克」卡回到卡组·额外卡组才能发动，对方场上1张卡回到卡组
function s.costfilter(c)
	return c:IsSetCard(0x666b) and c:IsFaceupEx() and c:IsAbleToDeckOrExtraAsCost()
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

-- 对方发动的效果的处理时，可以把场上的这张卡直到结束阶段除外，那个场合，那个效果无效化
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp == 1 - tp and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
	and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if Duel.SelectYesNo(tp, aux.Stringid(id,1)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Remove(c, POS_FACEUP, REASON_EFFECT + REASON_TEMPORARY)
		Duel.NegateEffect(ev)
		c:RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END,0,1)
		local fid = c:GetFieldID()
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE + PHASE_END)
		e1:SetReset(RESET_PHASE + PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1, tp)
	end
end

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc = e:GetLabelObject()
	if tc:GetFlagEffect(id) == 0 then
		e:Reset()
		return false
	else
		return true
	end
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
