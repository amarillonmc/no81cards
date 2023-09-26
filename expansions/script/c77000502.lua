--精灵封印者-士
local m=77000502
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(cm.atkval)
	c:RegisterEffect(e6)
	--Effect 2 
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(m,0))
	e13:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e13:SetType(EFFECT_TYPE_IGNITION)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1)
	e13:SetTarget(cm.target)
	e13:SetOperation(cm.operation)
	c:RegisterEffect(e13) 
	--Effect 3 
	--Effect 4 
	--Effect 5 
end
--Effect 1
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xee2)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.cfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
end
--Effect 2
function cm.tohfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xee2) 
end
function cm.sumfilter(c,e,tp)
	return  c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tohfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,cm.tohfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then
		local cg=Duel.GetMatchingGroup(cm.sumfilter,tp,0,LOCATION_HAND,nil,e,tp)
		if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)~=0 
			and cg:GetCount()>0 
			and Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local g=cg:Select(1-tp,1,1,nil)
			local tc=g:GetFirst()
			if tc and Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
--Effect 3 
--Effect 4 
--Effect 5   
