--落渊逆潮『法相皆空』
local cm,m=GetID()
function cm.initial_effect(c)
	-- 【卡片的发动】（绝对纯粹的空发动）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	-- ①：卡的效果发动时才能在连锁2·3发动。那个效果变成...
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return ev==1 or ev==2
	end)
	e2:SetTarget(cm.chtg)
	e2:SetOperation(cm.chop)
	c:RegisterEffect(e2)
	
	-- ②：把这张卡从手卡丢弃或从墓地除外才能发动。进行1只2阶怪兽的超量召唤。
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return (c:IsLocation(LOCATION_HAND) and c:IsDiscardable()) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()) end
		if c:IsLocation(LOCATION_HAND) then
			Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
		elseif c:IsLocation(LOCATION_GRAVE) then
			Duel.Remove(c,POS_FACEUP,REASON_COST)
		end
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then
			-- 给自身临时挂上“不能作为超量素材”的限制
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetValue(1)
			c:RegisterEffect(e1,true)
			-- 在此限制下进行合法性快照检测
			local res=Duel.IsExistingMatchingCard(function(tc) return tc:IsRank(2) and tc:IsXyzSummonable(nil) end,tp,LOCATION_EXTRA,0,1,nil)
			-- 检测完毕，立刻卸载临时限制
			e1:Reset()
			return res
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(function(tc) return tc:IsRank(2) and tc:IsXyzSummonable(nil) end,tp,LOCATION_EXTRA,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
		end
	end)
	c:RegisterEffect(e3)
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local att=0
		for tc in aux.Next(fg) do
			att=att|tc:GetAttribute()
		end
		if att==0 then return false end
		return Duel.IsExistingMatchingCard(function(tc) return tc:IsFaceup() and tc:GetAttribute()&att>0 and Duel.IsPlayerCanSendtoDeck(ep,tc) end,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil)
	end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=0
	local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local att=0
	for tc in aux.Next(fg) do
		att=att|tc:GetAttribute()
	end
	local g=Duel.GetMatchingGroup(function(tc) return tc:IsFaceup() and tc:GetAttribute()&att>0 and tc:IsAbleToDeck() end,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	while #g>0 do
		if count>0 then Duel.BreakEffect() end
		local exg=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		GRAVILOID_COUNTER=count
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if #og>0 or #exg~=exg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA) then
			count=count+1
			if GRAVILOID_COUNTER then e:GetHandler():SetTurnCounter(count) GRAVILOID_COUNTER=nil end
		else
			GRAVILOID_COUNTER=nil
			break
		end
		fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		att=0
		for tc in aux.Next(fg) do
			att=att|tc:GetAttribute()
		end
		g=Duel.GetMatchingGroup(function(tc) return tc:IsFaceup() and tc:GetAttribute()&att>0 and tc:IsAbleToDeck() end,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	end
	if count>0 then
		Duel.Draw(tp,count,REASON_EFFECT)
	end
end