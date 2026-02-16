-- 午夜战栗·深渊颤栗
function c10200064.initial_effect(c)
	-- Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- 效果1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200064,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c10200064.negcon)
	e1:SetTarget(c10200064.negtg)
	e1:SetOperation(c10200064.negop)
	c:RegisterEffect(e1)
end
-- 1
function c10200064.cfilter(c,seq)
	if not c:IsFaceup() or not c:IsSetCard(0xe25) or not c:IsLocation(LOCATION_MZONE) then return false end
	if not c:IsCanTurnSet() then return false end
	local cseq=c:GetSequence()
	if cseq>4 then
		if cseq==5 then cseq=1
		elseif cseq==6 then cseq=3 end
	end
	return cseq==seq
end
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
	elseif loc==LOCATION_FZONE then
		return -1
	elseif loc==LOCATION_PZONE then
		return -1
	end
	return seq
end
function c10200064.negcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) then return false end
	local rc=re:GetHandler()
	local seq=c10200064.getcolumnseq(rc)
	if seq<0 then return false end
	local g=Duel.GetMatchingGroup(c10200064.cfilter,tp,LOCATION_MZONE,0,nil,seq)
	if #g==0 then return false end
	e:SetLabelObject(g)
	return true
end
function c10200064.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c10200064.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g then return end
	local fg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #fg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local sg=fg:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if tc and tc:IsFaceup() and tc:IsCanTurnSet() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		if Duel.NegateEffect(ev) then
		end
	end
end
