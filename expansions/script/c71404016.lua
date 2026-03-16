--星忆锋芒
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.stellar_memories) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71404000,0)
		yume.import_flag=false
	end
	--①banish from deck or return to extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--②banished by 星芒之凝忆: remove + link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+100000)
	e2:SetCondition(yume.stellar_memories.BanishedSpellCon(71404007))
	e2:SetCost(yume.stellar_memories.LimitCost)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--③banished by 凝锋之星意: ritual summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+110000)
	e3:SetCondition(yume.stellar_memories.BanishedSpellCon(71404008))
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(yume.stellar_memories.RitualUltimateTarget("Greater",LOCATION_HAND,LOCATION_ONFIELD+LOCATION_EXTRA,nil))
	e3:SetOperation(yume.stellar_memories.RitualUltimateOperation("Greater",LOCATION_HAND,LOCATION_ONFIELD+LOCATION_EXTRA,nil))
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
end
--①
function s.filter1a(c,tp)
	return c:IsCode(71404007) and c:IsAbleToRemove(tp)
end
function s.filter1b(c)
	return c:IsCode(71404008) and c:IsAbleToDeck()
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1a,tp,LOCATION_DECK,0,1,nil,tp)
		or Duel.IsExistingMatchingCard(s.filter1b,tp,LOCATION_REMOVED,0,1,nil)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local bg=Duel.GetMatchingGroup(s.filter1a,tp,LOCATION_DECK,0,nil,tp)
	local rg=Duel.GetMatchingGroup(s.filter1b,tp,LOCATION_REMOVED,0,nil)
	if #bg>0 and (#rg==0 or Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=bg:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	elseif #rg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=rg:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
--②
function s.linkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_SPELLCASTER)
end
function s.rmfilter(c,tp)
	if not c:IsAbleToRemove(tp) then return false end
	local te=Effect.CreateEffect(c)
	te:SetType(EFFECT_TYPE_SINGLE)
	te:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	te:SetValue(1)
	c:RegisterEffect(te)
	local res=Duel.IsExistingMatchingCard(yume.stellar_memories.LinkSummonFilter,tp,LOCATION_EXTRA,0,1,nil)
	te:Reset()
	return res
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.linkfilter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return ct>0
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,ct,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.linkfilter,tp,LOCATION_ONFIELD,0,nil)
	local g=nil
	if ct>0 then
		g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp)
		if g:GetCount()<ct then
			g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp)
		end
		if g:GetCount()>=ct then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,ct,ct,nil)
			if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 and sg:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)>0 then
				Duel.BreakEffect()
				yume.stellar_memories.LinkSummonOp(e,tp,eg,ep,ev,re,r,rp)
			end
		end
	end
end