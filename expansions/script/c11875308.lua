--纹章觉醒
function c11875308.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_EQUIP) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_SZONE) 
	e1:SetCountLimit(1,11875308) 
	e1:SetTarget(c11875308.eqtg) 
	e1:SetOperation(c11875308.eqop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,11875308)  
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c11875308.sptg)
	e2:SetOperation(c11875308.spop)
	c:RegisterEffect(e2) 
end
c11875308.SetCard_tt_FireEmblem=true  
function c11875308.eqfil(c)   
	return c:IsType(TYPE_MONSTER) and c.SetCard_tt_FireEmblem and not c:IsForbidden()  
end 
function c11875308.xeqfil(c,e,tp) 
	return c:IsFaceup() and c:IsCode(11875299) and Duel.IsExistingMatchingCard(c11875308.eqfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c) 
end 
function c11875308.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11875308.xeqfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c11875308.xeqfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE) 
end
function c11875308.eqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c11875308.eqfil,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,tc) 
	local x=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if tc:IsRelateToEffect(e) and g:GetCount()>0 and x>0 then  
		local xeg=g:Select(tp,1,x,nil) 
		local ec=xeg:GetFirst() 
		while ec do 
		if not Duel.Equip(tp,ec,tc) then return end   
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		e1:SetLabelObject(tc)
		e1:SetValue(function(e,c)
		return e:GetLabelObject()==c end)
		ec:RegisterEffect(e1)
		local atk=tc:GetBaseAttack()
		if atk>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(atk) 
			ec:RegisterEffect(e2)
		end
		local def=tc:GetBaseDefense()
		if def>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE) 
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(def)
			ec:RegisterEffect(e2)
		end
		ec=xeg:GetNext() 
		end 
	end  
end 
function c11875308.spfil(c,e,tp)
	return c:IsCode(11875299) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11875308.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11875308.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c11875308.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11875308.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end 



