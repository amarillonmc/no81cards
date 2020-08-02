--未曾设想的道路
local m=33374566
local cm=_G["c"..m]
function c33374566.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetTarget(cm.target)
	--e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3734202,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	--Change name  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_ADD_SETCODE)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetTargetRange(0,LOCATION_MZONE)  
	e4:SetValue(0x558)
	c:RegisterEffect(e4)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.filter(c,e,sp)
	return c:IsCode(33374563) and c:IsCanBeSpecialSummoned(e,0,sp,true,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local cg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if cg:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp, aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=cg:Select(tp,1,1,nil):GetFirst()
			if  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
				 Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP) 
			else  
				 Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end 
		end
	end
end