--远古造物 梅氏利维坦鲸
dofile("expansions/script/c9910700.lua")
function c9910728.initial_effect(c)
	--special summon
	QutryYgzw.AddSpProcedure(c,3)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c9910728.tgtg)
	e1:SetOperation(c9910728.tgop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910728)
	e2:SetTarget(c9910728.distg)
	e2:SetOperation(c9910728.disop)
	c:RegisterEffect(e2)
end
function c9910728.tgfilter(c)
	return not c:IsPublic() or c:IsType(TYPE_MONSTER)
end
function c9910728.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if chk==0 then return mc>0 or g and g:IsExists(c9910728.tgfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE+LOCATION_HAND)
end
function c9910728.setfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and QutryYgzw.SetFilter(c,e,tp)
end
function c9910728.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local sg=g:Select(1-tp,1,1,nil)
	Duel.HintSelection(sg)
	local tc=sg:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_RULE)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local g2=Duel.GetMatchingGroup(c9910728.setfilter,tp,0,LOCATION_GRAVE,nil,e,tp)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910728,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg2=g2:Select(tp,1,1,nil)
			local tc2=sg2:GetFirst()
			if tc2 then QutryYgzw.Set(tc2,e,tp) end
		end
	end
end
function c9910728.negfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c9910728.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c9910728.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
