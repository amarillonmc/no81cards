--阿提纳诺-水之都
function c130000767.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3)

local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(130000767,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_TODECK)
	  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c130000767.retcon)
	e3:SetTarget(c130000767.targetr)
	e3:SetOperation(c130000767.operationr)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(130000767,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetRange(LOCATION_MZONE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c130000767.destg)
	e4:SetCost(c130000767.spcost)
	e4:SetOperation(c130000767.desop)
	c:RegisterEffect(e4)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c130000767.reptg)
	c:RegisterEffect(e7)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetCondition(c130000767.wincon)
	e5:SetOperation(c130000767.winop)
	c:RegisterEffect(e5)
end
function c130000767.retcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c130000767.filterd(c)
	return c:IsFaceup() 
end
function c130000767.targetr(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c130000767.filterd,tp,LOCATION_GRAVE,0,1,nil) end
end
function c130000767.operationr(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c130000767.filterd,tp,LOCATION_GRAVE,0,nil)
	local c=e:GetHandler()
	Duel.Overlay(e:GetHandler(),g)
end
function c130000767.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c130000767.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c130000767.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c130000767.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return true end
	if Duel.SelectYesNo(tp,aux.Stringid(130000767,2)) and g2:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		  Duel.SendtoDeck(sg2,nil,2,REASON_COST)
		return true
	else return false end
end
function c130000767.filter0(c,e,tp)
	return c:IsCode(130000766)  and c:IsFaceup()
end
function c130000767.wincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=50000 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 and 
Duel.IsExistingMatchingCard(c130000767.filter0,tp,LOCATION_ONFIELD,0,1,c,e,tp)
end
function c130000767.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,0x25)
end
