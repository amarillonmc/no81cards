--不死国的福音公爵
local s,id,o=GetID()
function s.initial_effect(c)
	-- 记载卡名
	aux.AddCodeList(c,98930401)
	
	-- ①效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	--记录召唤·特殊召唤的回合
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)
	local e0a=e0:Clone()
	e0a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e0a)
	local e0b=e0:Clone()
	e0b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e0b)

	--①：这张卡召唤·特殊召唤的自己·对方回合，把这张卡解放才能发动。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+3000)
	e1:SetCondition(s.ef1con)
	e1:SetCost(s.ef1cost)
	e1:SetTarget(s.ef1tg)
	e1:SetOperation(s.ef1op)
	c:RegisterEffect(e1)

	--②：自己·对方回合，自己场上有「怪兽（卡片id：98930401）」存在的场合...
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+10086)
	e2:SetCondition(s.ef2con)
	e2:SetCost(s.ef2cost)
	e2:SetTarget(s.ef2tg)
	e2:SetOperation(s.ef2op)
	c:RegisterEffect(e2)
end

-- 检查是否有对应位置的特召
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	for tc in aux.Next(eg) do
		if tc:IsPreviousLocation(LOCATION_HAND) then loc=loc|LOCATION_HAND end
		if tc:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA) then loc=loc|(LOCATION_DECK+LOCATION_EXTRA) end
		if tc:IsPreviousLocation(LOCATION_GRAVE) then loc=loc|LOCATION_GRAVE end
	end
	e:SetLabel(loc)
	return loc>0
end

-- 过滤：回卡组最下方的卡
function s.tdfilter(c)
	return (c:IsCode(98930401) or (c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and aux.IsCodeListed(c,98930401))) and c:IsAbleToDeck()
end
-- 过滤：从卡组除外的卡
function s.rmfilter(c)
	return c:IsCode(98930401) and c:IsAbleToRemove()
end

-- 效果发动目标与选择选项
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=e:GetLabel()
	local b1=(loc&LOCATION_HAND~=0) and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND,0,1,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=(loc&(LOCATION_DECK+LOCATION_EXTRA)~=0)
	local b3=(loc&LOCATION_GRAVE~=0) and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	
	if chk==0 then return b1 or b2 or b3 end
	
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,1) -- 提示语：让卡回到卡组特召
		opval[off]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2) -- 提示语：结束阶段特召
		opval[off]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,3) -- 提示语：除外卡组卡特召
		opval[off]=3
		off=off+1
	end
	
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op+1]
	e:SetLabel(sel)
	
	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	elseif sel==2 then
		-- 延迟特召不需要在当前立刻处理 SetOperationInfo，但可以不写
	elseif sel==3 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
end

-- 效果处理
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_HAND,0,1,1,c)
		if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_DECK) then
			if c:IsRelateToEffect(e) then
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	elseif sel==2 then
		if c:IsRelateToEffect(e) then
			-- 注册在结束阶段特殊召唤的效果
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetCondition(s.spcon)
			e1:SetOperation(s.spop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetLabelObject(c)
			Duel.RegisterEffect(e1,tp)
		end
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			if c:IsRelateToEffect(e) then
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

-- 结束阶段延迟特召的条件和处理
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and tc:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,id)
	if tc and tc:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--记录标记（持续到回合结束）
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end

--效果①相关
function s.ef1con(e,tp,eg,ep,ev,re,r,rp)
	--必须在召唤·特殊召唤的回合
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.ef1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.fieldfilter(c,tp)
	return c:IsCode(98930403) and c:IsType(TYPE_FIELD) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.ef1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.ef1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.fieldfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		--下个回合结束时回到卡组
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id+1)~=e:GetHandler():GetFieldID() then
		e:Reset()
		return false
	end
	return Duel.GetTurnCount()~=e:GetLabel()
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

--效果②相关
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(98930401)
end
function s.ef2con(e,tp,eg,ep,ev,re,r,rp)
	--不能在召唤·特殊召唤的回合发动，且自己场上必须有98930401
	return e:GetHandler():GetFlagEffect(id)==0
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.ef2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	--当作永续魔法卡
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function s.ef2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.ef2op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end