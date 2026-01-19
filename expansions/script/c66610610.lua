--圣弓天裁
local s,id,o=GetID()
function s.initial_effect(c)

	-- 对方从额外卡组把怪兽特殊召唤的场合才能发动，把对方的额外卡组的里侧的卡确认，选那之内的最多3张直到结束阶段里侧除外，那之后，把除外数量的卡从自己卡组上面里侧除外
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)	
end

-- 对方从额外卡组把怪兽特殊召唤的场合才能发动，把对方的额外卡组的里侧的卡确认，选那之内的最多3张直到结束阶段里侧除外，那之后，把除外数量的卡从自己卡组上面里侧除外
function s.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(1-tp)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,1-tp,LOCATION_EXTRA,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)
	if #g==0 then return end
	Duel.ConfirmCards(tp,g,true)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local maxnum = math.min(3, #g, Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0))
	local sg = g:FilterSelect(tp, aux.TRUE, 1, maxnum, nil)
	if #sg==0 then return end
	if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		og:KeepAlive()
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetOperation(s.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.ShuffleExtra(1-tp)
	local ct=#sg
	if ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct then
		local dg=Duel.GetDecktopGroup(tp,ct)
		Duel.DisableShuffleCheck()
		Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
	end
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		g:DeleteGroup()
	end
end
