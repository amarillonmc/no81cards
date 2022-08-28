local m=25000123
local cm=_G["c"..m]
cm.name="连接回路"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.splimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.drcost)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m+10000)
	e4:SetCondition(cm.sccon)
	e4:SetTarget(cm.sctg)
	e4:SetOperation(cm.scop)
	c:RegisterEffect(e4)
end
function cm.discon(e)
	return Duel.IsExistingMatchingCard(Card.IsExtraLinkState,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:GetMutualLinkedGroupCount()>0
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil) end
	local ft=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,ft,nil)
	local ct=0
	for tc in aux.Next(g) do ct=ct+tc:GetLink() end
	Duel.Release(g,REASON_COST)
	e:SetLabel(ct)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.filter(c,tp,zone)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then if c:IsControler(1-tp) then seq=seq+16 end else
		seq=c:GetPreviousSequence()
		if c:IsPreviousControler(1-tp) then seq=seq+16 end
	end
	return bit.extract(zone,seq)~=0
end
function cm.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function cm.sccon(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local lg=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(lg) do zone=bit.bor(zone,tc:GetLinkedZone(tp)) end
	return eg:IsExists(cm.filter,1,nil,tp,zone)
end
function cm.matfilter(c)
	return c:IsFaceup() and c:IsLinkState()
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,0,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,0,nil)):GetFirst()
	if tc then Duel.LinkSummon(tp,tc,Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,0,nil)) end
end
