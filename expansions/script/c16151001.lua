--SBK 企鹅
function c16151001.initial_effect(c)
   --link summon
	aux.AddLinkProcedure(c,c16151001.mfilter,1,1)
	c:EnableReviveLimit() 
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16151001,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c16151001.seqtg)
	e2:SetOperation(c16151001.seqop)
	c:RegisterEffect(e2)
end
function c16151001.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and not c:IsType(TYPE_LINK)
end
function c16151001.seqfilter(c)
	return true
end
function c16151001.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16151001.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16151001.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16151001,1))
	Duel.SelectTarget(tp,c16151001.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c16151001.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end