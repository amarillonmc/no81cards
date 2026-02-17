--午夜战栗·深渊颤栗
function c10200064.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--①：午夜战栗怪兽同纵列对方效果发动时，那只怪兽变里侧守备，效果无效
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200064,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c10200064.negcon)
	e1:SetTarget(c10200064.negtg)
	e1:SetOperation(c10200064.negop)
	c:RegisterEffect(e1)
end
--①效果
function c10200064.getcolumnseq(c)
	local loc=c:GetLocation()
	local seq=c:GetSequence()
	if loc==LOCATION_MZONE then
		if seq>4 then
			if seq==5 then seq=1
			elseif seq==6 then seq=3 end
		end
	elseif loc==LOCATION_SZONE then
		if seq>4 then return -1 end
	elseif loc==LOCATION_FZONE or loc==LOCATION_PZONE then
		return -1
	end
	return seq
end
function c10200064.cfilter(c,seq,tp)
	if not c:IsFaceup() or not c:IsSetCard(0xe25) or not c:IsLocation(LOCATION_MZONE) then return false end
	if not c:IsControler(tp) then return false end
	if not c:IsCanTurnSet() then return false end
	local cseq=c:GetSequence()
	if cseq>4 then
		if cseq==5 then cseq=1
		elseif cseq==6 then cseq=3 end
	end
	return cseq==seq
end
function c10200064.negcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) then return false end
	local rc=re:GetHandler()
	local seq=c10200064.getcolumnseq(rc)
	if seq<0 then return false end
	local g=Duel.GetMatchingGroup(c10200064.cfilter,tp,LOCATION_MZONE,0,nil,seq,tp)
	if #g==0 then return false end
	e:SetLabel(seq)
	return true
end
function c10200064.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local seq=e:GetLabel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10200064.cfilter(chkc,seq,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10200064.cfilter,tp,LOCATION_MZONE,0,1,nil,seq,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,c10200064.cfilter,tp,LOCATION_MZONE,0,1,1,nil,seq,tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c10200064.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanTurnSet() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		Duel.NegateEffect(ev)
	end
end
