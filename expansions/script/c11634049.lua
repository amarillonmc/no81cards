--连接调度员
local cm,m=GetID()

function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCondition(cm.spcon)
	e1:SetValue(cm.spval)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(0x04)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end

function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,Duel.GetLinkedZone(tp))>0
end

function cm.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end

function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x02,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsType(TYPE_LINK) and chkc:IsLocation(0x04) and chkc:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0x04,0,1,nil,TYPE_LINK) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsType,tp,0x04,0,1,1,nil,TYPE_LINK)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		Duel.Hint(HINT_ZONE,tp,fd)
		Duel.MoveSequence(tc,math.log(fd,2))
	end
end