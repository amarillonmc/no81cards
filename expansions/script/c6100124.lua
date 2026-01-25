--女神之令-归蝶
local s,id=GetID()
function s.initial_effect(c)
	--①：展示手卡发动（二速）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.e1con)
	e1:SetCost(s.e1cost)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	--②：丢弃手卡，回手 & 可选除外（二速）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.e2cost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end

--------------------------------------------------------------------------------
-- ①效果
--------------------------------------------------------------------------------

function s.e1con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_MZONE) or e:GetHandler():GetFlagEffect(id)>0
end

function s.spfilter(c)
	return c:IsAbleToDeck() or c:IsAbleToExtra()
end

--Cost过滤：展示本家S/T
function s.rvfilter(c,e,tp,mc)
	if not (c:IsSetCard(0x611) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsPublic()) then return false end
	
	--分支1：魔法卡 -> 展示卡送墓，检索仪式
	if c:IsType(TYPE_SPELL) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
	
	--分支2：陷阱卡 -> 自身送墓，盖放展示卡
	elseif c:IsType(TYPE_TRAP) then
		return mc:IsAbleToGrave() --自身要能送墓
			and c:IsSSetable()
	end
	return false
end

function s.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,c)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst()) --记录展示的卡
	Duel.ShuffleHand(tp)
end

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetLabelObject()
	if chk==0 then return true end
	
	if rc:IsType(TYPE_SPELL) then
		e:SetCategory(CATEGORY_TODECK)
		--提示：展示卡送墓
		Duel.SetOperationInfo(0,CATEGORY_TODECK,rc,1,0,0)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		--提示：自身送墓
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	end
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject() --展示的卡
	local c=e:GetHandler()  --自身
	
	if rc:IsType(TYPE_SPELL) then
		if rc:IsLocation(LOCATION_HAND) and Duel.SendtoGrave(rc,REASON_EFFECT)>0 and rc:IsLocation(LOCATION_GRAVE)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			end
		end
		
	elseif rc:IsType(TYPE_TRAP) then
		--●陷阱卡：这张卡送去墓地。给人观看的陷阱卡在自己场上盖放。
		if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE) then
			--rc还在手卡，盖放它
			if rc:IsLocation(LOCATION_HAND) and rc:IsSSetable() then
				Duel.SSet(tp,rc)
				--盖放的回合也能发动
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e1)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- ②效果
--------------------------------------------------------------------------------

function s.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	--检查丢弃的卡是否是本家
	if g:GetFirst():IsSetCard(0x611) then
		e:SetLabel(1) --标记：满足追加效果条件
	else
		e:SetLabel(0)
	end
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--1. 回到手卡
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,nil,1,0)
		
		--2. 追加效果：除外对方墓地
		if e:GetLabel()==1 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			--选最多3张
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,3,nil)
			if #g>0 then
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end