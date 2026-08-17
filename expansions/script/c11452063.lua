--界落渊鸣『生住异灭』
local cm,m=GetID()
function cm.initial_effect(c)
	-- 【卡片的发动】
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(cm.actcost)
	c:RegisterEffect(e0)
	-- 【怪兽效果】①：怪兽卡的效果发动的场合才能发动。（场上的诱发效果）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		--immune
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD)
		ge5:SetCode(EFFECT_IMMUNE_EFFECT)
		ge5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge5:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		ge5:SetTarget(function(e,c) return c:IsFaceup() end)
		ge5:SetValue(cm.immval)
		Duel.RegisterEffect(ge5,0)
	end
end
-- =========================================
-- 发动与Cost
-- =========================================
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x1974,1,c) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsCanAddCounter(0x1974,1) then
		Duel.HintSelection(Group.FromCards(c))
		local ct=Duel.AnnounceNumber(tp,1,2,3)
		c:AddCounter(0x1974,ct)
	end
	--[[if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1974,1) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		for i=1,3 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local g=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,0x1974,1)
			if #g>0 then
				local prop1,prop2=e:GetProperty()
				e:SetProperty(prop1|EFFECT_FLAG_IGNORE_IMMUNE,prop2)
				g:GetFirst():AddCounter(0x1974,1)
				e:SetProperty(prop1,prop2)
			end
		end
	end--]]
end
-- =========================================
-- ① 诱发效果处理
-- =========================================
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetOriginalType()&TYPE_MONSTER>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(tc) return tc:GetSequence()<5 and math.abs(tc:GetSequence()-c:GetSequence())<=1 end,tp,LOCATION_SZONE,0,nil)+c:GetColumnGroup()
	if chk==0 then return g:IsExists(Card.IsAbleToDeck,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,LOCATION_ONFIELD)
end
function cm.thfilter(c)
	return c:IsSetCard(0x5978) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=0
	local g=Duel.GetMatchingGroup(function(tc) return tc:GetSequence()<5 and math.abs(tc:GetSequence()-c:GetSequence())<=1 end,tp,LOCATION_SZONE,0,nil)+c:GetColumnGroup()
	g=g:Filter(Card.IsAbleToDeck,nil)
	while #g>0 do
		if count>0 then Duel.BreakEffect() end
		local fg=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
		GRAVILOID_COUNTER=count
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=#og
		if ct>0 or #fg~=fg:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD) then
			count=count+1
			if GRAVILOID_COUNTER then e:GetHandler():SetTurnCounter(count) GRAVILOID_COUNTER=nil end
		else
			GRAVILOID_COUNTER=nil
			break
		end
		if not c:IsRelateToEffect(e) then break end
		g=Duel.GetMatchingGroup(function(tc) return tc:GetSequence()<5 and math.abs(tc:GetSequence()-c:GetSequence())<=1 end,tp,LOCATION_SZONE,0,nil)+c:GetColumnGroup()
		g=g:Filter(Card.IsAbleToDeck,nil)
	end
	if count>0 then
		local thg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
		if #thg>=count then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=thg:Select(tp,count,count,nil)
			if #sg>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
			end
		end
	end
end
-- =========================================
-- 高级抗性检测与指示物扣除
-- =========================================
local KOISHI_CHECK=false
if Duel.DisableActionCheck then KOISHI_CHECK=true end
function cm.immval(e,te,c)
	if not (not te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and (te:GetCode()<0x10000 or te:IsHasType(EFFECT_TYPE_ACTIONS)) and (Duel.IsChainSolving() or not te:IsActivated())) then return false end
	local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+m)}
	local eset2={c:IsHasEffect(EFFECT_FLAG_EFFECT+m-1)}
	local ctns=false
	if not te:IsHasType(EFFECT_TYPE_ACTIONS) then
		for _,se in pairs(eset) do
			if se:GetLabelObject()==te then ctns=true end
		end
	else
		for _,se in pairs(eset2) do
			if se:GetLabelObject()==te and se:GetLabel()==Duel.GetCurrentChain() then ctns=true end
		end
	end
	local res=ctns or c:GetCounter(0x1974)>c:GetFlagEffect(m-3)
	if res and not ctns then
		if KOISHI_CHECK then
			Duel.DisableActionCheck(true)
			pcall(Card.RemoveCounter,c,tp,0x1974,1,REASON_EFFECT)
			--Debug.Message(e:GetHandler():GetLocation())
			Duel.DisableActionCheck(false)
		else
			Duel.Hint(HINT_CARD,0,m)
			c:RegisterFlagEffect(m-3,RESET_EVENT+RESETS_STANDARD,0,1)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_ADJUST)
			e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e4:SetOperation(cm.imcop)
			Duel.RegisterEffect(e4,tp)
		end
		local ge1=c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		ge1:SetLabelObject(te)
		if te:IsHasType(EFFECT_TYPE_ACTIONS) then
			local ge2=c:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
			ge2:SetLabelObject(te)
			ge2:SetLabel(Duel.GetCurrentChain())
			local e8=Effect.CreateEffect(e:GetHandler())
			e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e8:SetCode(EVENT_BREAK_EFFECT)
			e8:SetOperation(function(fe) ge2:SetLabelObject(nil) fe:Reset() end)
			Duel.RegisterEffect(e8,0)
			local e9=e8:Clone()
			e9:SetCode(EVENT_ADJUST)
			Duel.RegisterEffect(e9,0)
		end
	end
	return res
end
function cm.imcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(m-3)
	c:ResetFlagEffect(m-3)
	if ct>0 then c:RemoveCounter(tp,0x1974,ct,REASON_EFFECT) end
end 