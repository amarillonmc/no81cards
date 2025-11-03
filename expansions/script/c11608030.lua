--飓风乱流舞者 辛
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),7,2)
	
	--material effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.matcon)
	e1:SetTarget(s.mattg)
	e1:SetOperation(s.matop)
	c:RegisterEffect(e1)
	
	--draw and attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	
	--return to deck - 二速效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,id+o*2)
	e3:SetCost(s.rtcost)
	e3:SetTarget(s.rttg)
	e3:SetOperation(s.rtop)
	c:RegisterEffect(e3)
end
function s.mark_as_faceup(c)
	if c:GetLocation()==LOCATION_DECK then
		c:ReverseInDeck()
		c:RegisterFlagEffect(id+1000,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		-- 同一连锁上不能发动
		if Duel.GetFlagEffect(tp,id)~=0 then return false end
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 
	end
	-- 注册连锁标志
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end

function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount<5 then return end
	
	Duel.ConfirmDecktop(tp,5)
	local revealed = Duel.GetDecktopGroup(tp, 5)
	
	local attach_count = math.min(2, revealed:GetCount())
	if attach_count > 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local attach_group = revealed:Select(tp,1,attach_count,nil)
		if attach_group:GetCount() > 0 then
			Duel.Overlay(c,attach_group)
			revealed:Sub(attach_group)
		end
	end
	
	local return_count = revealed:GetCount()
	if return_count > 0 then
		-- 确保卡片表面向上放回卡组
		for tc in aux.Next(revealed) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_DECKSHF)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e1)
		end
		Duel.SendtoDeck(revealed,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		for tc in aux.Next(revealed) do
			s.mark_as_faceup(tc)
		end
	end
end

-- ②效果
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x9225) and re:GetHandler():GetLocation()==LOCATION_DECK
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		-- 同一连锁上不能发动
		if Duel.GetFlagEffect(tp,id)~=0 then return false end
		return Duel.IsPlayerCanDraw(tp,2) 
	end
	-- 注册连锁标志
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Draw(tp,2,REASON_EFFECT)==2 and c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=g:Select(tp,1,1,nil)
			if #sg>0 then
				local tc=sg:GetFirst()
				-- 如果是超量怪兽且有超量素材，先将其超量素材送去墓地
				if tc:IsType(TYPE_XYZ) and tc:GetOverlayCount()>0 then
					local og=tc:GetOverlayGroup()
					if og:GetCount()>0 then
						Duel.SendtoGrave(og,REASON_RULE)
					end
				end
				Duel.Overlay(c,sg)
			end
		end
	end
end

-- ③效果 - 完全重写以避免协程错误
function s.rtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 同一连锁上不能发动
		if Duel.GetFlagEffect(tp,id)~=0 then return false end
		-- 检查场上是否有可以返回卡组的卡
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	-- 注册连锁标志
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end

function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	-- 选择场上1张卡返回卡组
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		-- 确保卡片表面向上放回卡组
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_DECKSHF)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		s.mark_as_faceup(tc)
	end
end