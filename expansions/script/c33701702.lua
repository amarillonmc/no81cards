--天地颠倒的谐谑曲
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.con)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_LEAVE_GRAVE)
	c:RegisterEffect(e4)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_REFLECT_DAMAGE)
	e4:SetTargetRange(1,1)
	e4:SetValue(s.val)
	e4:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1191)
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.tgtg)
	e5:SetOperation(s.tgop)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetOperation(s.lpop)
	c:RegisterEffect(e6)
end
function s.val(e,re,ev,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function s.repfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:GetDestination()==LOCATION_HAND and c:IsAbleToRemove(tp,POS_FACEDOWN) and bit.band(c:GetReason(),REASON_DRAW)==0
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) end
	local g=eg:Filter(s.repfilter,nil,tp)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		return true
	else return false end
end
function s.repval(e,c)
	return false
end
function s.filter(c,tp)
	return c:GetFlagEffect(id)==0 and c:IsControler(tp)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if #eg==0 then return end
	local g1=eg:Filter(s.filter,nil,tp)
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,#g1,#g1,nil)
		if #sg>0 then
			Duel.HintSelection(sg)
			for tc in aux.Next(sg) do
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TODECK,0,1)
			end
			if Duel.SendtoDeck(sg,nil,1,REASON_RULE)>0 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
				local tg=Duel.GetDecktopGroup(tp,1)
				if #tg>0 then
					tg:GetFirst():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE,0,1)
					Duel.DiscardDeck(tp,1,REASON_EFFECT)
				end
			end
		end
	end
	local g2=eg:Filter(s.filter,nil,1-tp)
	if #g2>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local sg2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_GRAVE,0,#g2,#g2,nil)
		if #sg2>0 then
			Duel.HintSelection(sg2)
			for tc2 in aux.Next(sg2) do
				tc2:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TODECK,0,1)
			end
			if Duel.SendtoDeck(sg2,nil,1,REASON_RULE)>0 and sg2:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
				local tg2=Duel.GetDecktopGroup(1-tp,1)
				if #tg2>0 then
					tg2:GetFirst():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE,0,1)
					Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
				end
			end
		end
	end
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(Duel.GetTurnPlayer(),2) end
	Duel.SetTargetPlayer(1-Duel.GetTurnPlayer())
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-Duel.GetTurnPlayer(),2000)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(Duel.GetTurnPlayer(),2)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		Duel.BreakEffect()
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	Duel.SetLP(tp,lp2)
	Duel.SetLP(1-tp,lp1)
end