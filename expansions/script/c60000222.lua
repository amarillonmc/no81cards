-- 亚特兰蒂斯的挽歌 (60000222)
local s,id=GetID()

function s.initial_effect(c)
	aux.AddCodeList(c,60000211) -- 关联拉弥亚·深谣
	-- 效果1：发动场地
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)
	
	-- 效果2（优化表侧判断）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.excost)
	e2:SetTarget(s.extg)
	e2:SetOperation(s.exop)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end

-- 效果1目标
function s.filter(c,tp)
	return c:IsCode(60000223) -- 仅限矢车菊之暗
		and (c:IsLocation(LOCATION_HAND+LOCATION_DECK))
		and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
end

-- 效果1操作
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		-- 处理已有场地
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		
		-- 移动并发动
		if tc:IsLocation(LOCATION_HAND) then
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
		
		-- 从手卡发动时抽卡
		if tc:IsPreviousLocation(LOCATION_HAND) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		
		-- 触发场地效果
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end
-- 效果2cost
function s.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

-- 效果2目标
function s.exfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and aux.IsCodeListed(c,60000211) and not c:IsCode(id)
end
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_REMOVED,0,3,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_REMOVED)
end

-- 效果2操作
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_REMOVED,0,nil)
	if #g<3 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:Select(tp,3,3,nil)
	if #sg~=3 then return end
	
	local op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	if op==0 then
		-- 返回卡组抽2
		for tc in aux.Next(sg) do
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,2,REASON_EFFECT)
	else
		-- 送墓除外手卡
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #hg>0 then
			local rc=hg:RandomSelect(tp,1):GetFirst()
			Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end