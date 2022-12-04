--阻 绝 人 迹 之 桥
local m=22348111
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c22348111.discon)
	e2:SetOperation(c22348111.disop)
	c:RegisterEffect(e2)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c22348111.condition1)
	e2:SetCost(c22348111.cost)
	e2:SetTarget(c22348111.target1)
	e2:SetOperation(c22348111.operation1)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22348111.tgcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c22348111.tgtg)
	e3:SetOperation(c22348111.tgop)
	c:RegisterEffect(e3)
end
function c22348111.disfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:IsSetCard(0x704) and seq1==4-seq2
end
function c22348111.discon(e,tp,eg,ep,ev,re,r,rp)
	local htp1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local htp2=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return not Duel.IsExistingMatchingCard(c22348111.disfilter,tp,LOCATION_MZONE,0,1,nil,seq) and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and htp1<htp2 
end
function c22348111.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348111)
	Duel.NegateEffect(ev)
end
function c22348111.filter(c,tp)
	return c:IsSetCard(0x704) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c22348111.condition1(e,tp,eg,ep,ev,re,r,rp)
	local htp1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local htp2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	return eg:IsExists(c22348111.filter,1,nil,tp) and htp1<htp2
end
function c22348111.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end
function c22348111.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348111.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c22348111.tgcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local htp1=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	local htp2=Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0)
	return htp1<htp2
end
function c22348111.tgfilter(c)
	return c:IsSetCard(0x704) and c:IsAbleToGrave()
end
function c22348111.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348111.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c22348111.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348111.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end










