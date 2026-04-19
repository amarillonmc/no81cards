-- 示例通常魔法卡
local s,id,o=GetID()
function s.initial_effect(c)
	-- 发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 选项1的过滤：找示例卡1
function s.tf_filter(c,tp)
	return c:IsCode(98930403) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
-- 选项2的过滤：手牌示例卡2或记述示例卡2的永续陷阱
function s.td_filter1(c)
	return (c:IsCode(98930401) or (c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and aux.IsCodeListed(c,98930401))) 
		and c:IsAbleToDeck()
end
-- 选项3的过滤：场上/墓地记述示例卡2的永续陷阱
function s.td_filter2(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) 
		and aux.IsCodeListed(c,98930401) and c:IsAbleToDeck()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 判定3个选项的发动条件与Flag限制
	local b1=Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(s.tf_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	local b2=Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.td_filter1,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	local b3=Duel.GetFlagEffect(tp,id+2)==0 and Duel.IsExistingMatchingCard(s.td_filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
	
	if chk==0 then return b1 or b2 or b3 end
	
	local op=0
	if b1 and b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,2))
		if op==1 then op=2 end
	elseif b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))+1
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+2
	end
	e:SetLabel(op)
	-- 给对应选项注册1回合1次标签
	Duel.RegisterFlagEffect(tp,id+op,RESET_PHASE+PHASE_END,0,1)
	
	if op==1 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	elseif op==2 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	else
		e:SetCategory(0)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		-- ●选1张「示例卡1」在场地区域表侧表示放置
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tf_filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
		
	elseif op==1 then
		-- ●手卡回底抽2
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.td_filter1,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup()
			if og:GetFirst():IsLocation(LOCATION_DECK) then
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
		
	elseif op==2 then
		-- ●选最多3张洗回卡组，若3张则可破坏1卡
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.td_filter2),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,3,nil)
		if #g>0 then
			Duel.HintSelection(g)
			local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			if ct==3 then
				local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
				if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
					local sg=dg:Select(tp,1,1,nil)
					Duel.HintSelection(sg)
					Duel.Destroy(sg,REASON_EFFECT)
				end
			end
		end
	end
end