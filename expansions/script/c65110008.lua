--拉赫皇女 阿依莎
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65110000)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(aux.IsCodeListed,65110000))
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetLabelObject(e1)
	e2:SetCost(s.ovcost)
	e2:SetTarget(s.ovtg)
	e2:SetOperation(s.ovop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return aux.IsCodeListed(c,65110000) and c:IsAbleToDeckAsCost()
end
function s.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.ovfilter(c,e)
	return c:IsFaceup() and c:IsCode(65110000) and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local oe=e:GetLabelObject()
	local oe1=oe:Clone()
	local g=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 and g:GetCount()>0 and c:IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		local sc=g:GetFirst()
		if g:GetCount()>1 then sc=g:Select(tp,1,1,nil):GetFirst() end
		local seq=c:GetSequence()
		local etype=oe1:GetType()
		local con=oe1:GetCondition()
		if not con then con=aux.TRUE end
		oe1:SetCondition(s.chcon(con,seq))
		oe1:SetType(etype|EFFECT_TYPE_XMATERIAL)
		if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
			oe1:SetRange(LOCATION_SZONE)
		end
		c:RegisterEffect(oe1)
		local re=Effect.CreateEffect(c)
		re:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		re:SetRange(0xff)
		re:SetCode(EVENT_ADJUST)
		re:SetLabelObject(oe1)
		re:SetOperation(s.resetop)
		c:RegisterEffect(re)
		Duel.Overlay(sc,c)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function s.chcon(con,seq)
	return function(e,tp,...)
				if Duel.GetFieldCard(tp,LOCATION_MZONE,seq) then return false end
				return con(e,tp,...)
			end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
