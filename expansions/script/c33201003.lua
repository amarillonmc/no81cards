--治安战警队 散射光子
local m=33201003
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(3,m+10000
)
	e2:SetTarget(cm.seqtg)
	e2:SetOperation(cm.seqop)
	c:RegisterEffect(e2)
end
function cm.tdfilter(c,tp)
	return c:IsSetCard(0x156) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToHandAsCost() and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c)
end
function cm.thfilter(c)
	return c:IsSetCard(0x156) and c:IsAbleToDeckAsCost() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.tdfilter2(c,tp,g)
	return c:IsSetCard(0x156) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToHandAsCost() and g:IsExists(cm.thfilter,1,c)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),tp)
end
function cm.check(c)
	return c:IsSetCard(0x156) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.gcheck(g,tp)
	return g:IsExists(cm.tdfilter2,1,nil,tp,g)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local dg = Duel.GetMatchingGroup(cm.check,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=dg:SelectSubGroup(tp,cm.gcheck,false,2,2,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=g:FilterSelect(tp,cm.tdfilter2,1,1,nil,tp,g)
	g:Sub(tc)
	Duel.SendtoHand(tc,tp,REASON_COST)
	Duel.SendtoDeck(g,tp,2,REASON_COST)
end
function cm.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x156)
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	Duel.SelectTarget(tp,cm.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end