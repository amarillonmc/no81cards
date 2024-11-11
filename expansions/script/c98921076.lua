--振翼之圣像骑士
function c98921076.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c98921076.matcheck)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98921076.atkval)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c98921076.atklimit)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98921076,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98921076)
	e3:SetCondition(c98921076.seqcon)
	e3:SetTarget(c98921076.seqtg)
	e3:SetOperation(c98921076.seqop)
	c:RegisterEffect(e3)
end
function c98921076.matcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x116)
end
function c98921076.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
	return g:GetSum(Card.GetBaseAttack)
end
function c98921076.atklimit(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c98921076.seqcfilter(c,tp,lg)
	return c:IsType(TYPE_EFFECT) and lg:IsContains(c)
end
function c98921076.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c98921076.seqcfilter,1,nil,tp,lg)
end
function c98921076.seqfilter(c)
	local tp=c:GetControler()
	return c:GetSequence()<5 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
end
function c98921076.setfilter(c,e,tp)
	if not c:IsSetCard(0x116) then return false end
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else return c:IsSSetable() end
end
function c98921076.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98921076.setfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98921076.setfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c98921076.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetFirst():IsType(TYPE_MONSTER) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function c98921076.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local res=0
	if tc:IsType(TYPE_MONSTER) then
		res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		if res~=0 then Duel.ConfirmCards(1-tp,tc) end
	else
		res=Duel.SSet(tp,tc)
	end
	if res~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
		if tc:IsType(TYPE_QUICKPLAY) or tc:IsType(TYPE_TRAP) then
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetDescription(aux.Stringid(88332693,2))
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		   e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e1)
		   local e2=e1:Clone()
		   e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		   tc:RegisterEffect(e2)
		end
	end
end