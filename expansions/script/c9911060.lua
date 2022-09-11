--恋慕屋敷的舞娘
function c9911060.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9911060.spcon)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9911060.drcon)
	e2:SetTarget(c9911060.drtg)
	e2:SetOperation(c9911060.drop)
	c:RegisterEffect(e2)
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9911060.chcon)
	e3:SetOperation(c9911060.chop)
	c:RegisterEffect(e3)
end
function c9911060.spcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9954) and not c:IsRace(RACE_WINDBEAST)
end
function c9911060.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911060.spcfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c9911060.filter(c)
	return c:GetCounter(0x1954)>0
end
function c9911060.drcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
		and Duel.IsExistingMatchingCard(c9911060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function c9911060.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=Duel.GetMatchingGroupCount(c9911060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,gc+1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,gc+1)
end
function c9911060.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local gc=Duel.GetMatchingGroupCount(c9911060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if gc>0 and Duel.Draw(p,gc+1,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(p)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,gc,gc,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
function c9911060.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c9911060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil)
end
function c9911060.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,c9911060.repop)
end
function c9911060.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9911060)
	Duel.RemoveCounter(tp,1,1,0x1954,2,REASON_EFFECT)
end
