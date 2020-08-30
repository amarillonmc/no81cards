local m=82204250
local cm=_G["c"..m]
cm.name="烽火骁骑·黛尔"
function cm.initial_effect(c)
	--cannot remove  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE) 
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2) 
	--special summon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_GRAVE)  
	e3:SetCountLimit(1,m+10000)  
	e3:SetCost(cm.spcost2)  
	e3:SetTarget(cm.sptg2)  
	e3:SetOperation(cm.spop2)  
	c:RegisterEffect(e3)   
end
function cm.filter(c,e,tp)  
	return c:IsSetCard(0x129a) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP) 
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsReleasable() end  
	Duel.Release(e:GetHandler(),REASON_COST)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1  
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	local tc=g:GetFirst()  
	local c=e:GetHandler()  
	if tc then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
		local e1=Effect.CreateEffect(c)  
		e1:SetDescription(aux.Stringid(m,2))  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)  
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
		e1:SetValue(1)  
		e1:SetReset(RESET_EVENT+0x1fe0000)  
		tc:RegisterEffect(e1)   
	end  
end  
function cm.cfilter(c,tp)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x129a) and c:IsReleasable() and 
	Duel.GetMZoneCount(tp,c)>0
end  
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,0x06,0,1,nil,tp) end  
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,0x06,0,1,1,nil,tp)  
	Duel.Release(g,REASON_COST)  
end  
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,0x06,0,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then  
		local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0x1c,0x1c,nil)  
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then  
			Duel.BreakEffect()  
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
			local dg=g:Select(tp,1,1,nil)  
			Duel.HintSelection(dg)  
			Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)  
		end  
	end  
end  
function cm.rmfilter(c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end  