--你要抓住的 不再是我了
function c32100018.initial_effect(c)
	aux.AddCodeList(c,32100002) 
	--spsummon
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCost(c32100018.spcost)
	e1:SetTarget(c32100018.sptg)
	e1:SetOperation(c32100018.spop)
	c:RegisterEffect(e1) 
end
function c32100018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsCode(32100002) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(function(c) return c:IsCode(32100003) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_GRAVE,0,3,nil) end 
	local g1=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(32100002) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_GRAVE,0,1,1,nil) 
	local g2=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(32100003) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_GRAVE,0,3,3,nil)  
	g1:Merge(g2) 
	Duel.Remove(g1,POS_FACEUP,REASON_COST) 
end 
function c32100018.spfilter(c,e,tp)
	return c:IsCode(32100013) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end
function c32100018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32100018.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		Duel.SetChainLimit(c32100018.chlimit)
	end 
end
function c32100018.chlimit(e,ep,tp)
	return tp==ep
end
function c32100018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c32100018.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		--cannot be destroyed
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		--pierce
		local e2=Effect.CreateEffect(tc) 
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE) 
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		--atk
		local e2=Effect.CreateEffect(tc)
		e2:SetDescription(aux.Stringid(32100018,1)) 
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTarget(c32100018.atktg) 
		e2:SetOperation(c32100018.atkop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		if not tc:IsType(TYPE_EFFECT) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetValue(TYPE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
		end	   
	end 
end
function c32100018.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToGraveAsCost() and c.SetCard_HR_Corecoin end,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToGraveAsCost() and c.SetCard_HR_Corecoin end,tp,LOCATION_HAND,0,1,1,nil) 
	local x=Duel.SendtoGrave(g,REASON_COST) 
	e:SetLabel(x)
end 
function c32100018.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=e:GetLabel()
	if c:IsRelateToEffect(e) and x and x>0 then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(x*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
	end 
end 

