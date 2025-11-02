--极顶乱流舞者 索姆
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,7,3,nil,nil,99)
	
	--return 1 card to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.rtcost1)
	e1:SetTarget(s.rttg1)
	e1:SetOperation(s.rtop1)
	c:RegisterEffect(e1)
	
	--continuous effect: return detached materials to deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.rtcon2)
	e2:SetOperation(s.rtop2)
	c:RegisterEffect(e2)
	
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.chcon)
	e3:SetCost(s.chcost)
	e3:SetTarget(s.chtg)
	e3:SetOperation(s.chop)
	c:RegisterEffect(e3)
	
	-- 添加全局效果处理表侧卡
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_END)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsPosition,p,LOCATION_DECK,0,nil,POS_FACEUP_DEFENSE)
		local g2=Duel.GetFieldGroup(p,LOCATION_EXTRA,0)
		if #g2>0 then
			Duel.ConfirmCards(p,g+g2,true)
		end
	end
end

function s.rtcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.rttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end

function s.rtop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		-- 使用正确的方法将卡片表面向上放回卡组
		local tc=g:GetFirst()
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		tc:ReverseInDeck()
		tc:RegisterFlagEffect(id+1000,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

function s.rtcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_OVERLAY)
end

function s.rtop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_OVERLAY)
	if #g>0 then
		-- 将超量素材返回卡组（不表面向上）
		for tc in aux.Next(g) do
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	end
end

-- 修改③效果，参考于贝尔的幻影
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end

function s.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	-- 双方各自从自身场上选1张卡回到卡组
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g1:Select(tp,1,1,nil)
		if #sg1>0 then
			-- 使用正确的方法将卡片表面向上放回卡组
			local tc=sg1:GetFirst()
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			tc:ReverseInDeck()
			tc:RegisterFlagEffect(id+1000,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
	
	if #g2>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local sg2=g2:Select(1-tp,1,1,nil)
		if #sg2>0 then
			-- 使用正确的方法将卡片表面向上放回卡组
			local tc=sg2:GetFirst()
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			tc:ReverseInDeck()
			tc:RegisterFlagEffect(id+1000,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end