--纹章结合
function c11875306.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c11875306.target)
	e1:SetOperation(c11875306.activate)
	c:RegisterEffect(e1) 
	--Equip 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11875306,1)) 
	e2:SetCategory(CATEGORY_EQUIP) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c11875306.eqtg) 
	e2:SetOperation(c11875306.eqop) 
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(11875306,2)) 
	e3:SetCategory(CATEGORY_EQUIP) 
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_FZONE) 
	e3:SetCountLimit(1) 
	e3:SetTarget(c11875306.sptg) 
	e3:SetOperation(c11875306.spop) 
	c:RegisterEffect(e3) 
end  
c11875306.SetCard_tt_FireEmblem=true  
function c11875306.filter(c,e,tp)
	return c:IsCode(11875299) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11875306.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c.SetCard_tt_FireEmblem   
end 
function c11875306.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c11875306.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c11875306.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) 
	local b2=Duel.IsExistingMatchingCard(c11875306.thfil,tp,LOCATION_DECK,0,1,nil) 
	if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(11875306,0)) then 
		local op=2  
		if b1 and b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(11875306,2),aux.Stringid(11875306,3)) 
		elseif b1 then 
			op=Duel.SelectOption(tp,aux.Stringid(11875306,2)) 
		elseif b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(11875306,3))+1 
		end  
		if op==1 then 
			local g=Duel.SelectMatchingCard(tp,c11875306.thfil,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,tp,REASON_EFFECT) 
				Duel.ConfirmCards(1-tp,g)   
			end 
		elseif op==0 then 
			local g=Duel.SelectMatchingCard(tp,c11875306.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end  
	end 
end 
function c11875306.eqfil(c)   
	return c:IsType(TYPE_MONSTER) and c.SetCard_tt_FireEmblem and not c:IsForbidden()  
end 
function c11875306.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsCode(11875299) end,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c11875306.eqfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end 
	local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsCode(11875299) end,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE) 
end
function c11875306.eqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c11875306.eqfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,nil)
	if tc:IsRelateToEffect(e) and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
		local ec=g:Select(tp,1,1,nil):GetFirst() 
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
	end  
end 
function c11875306.spfil(c,e,tp)
	return c.SetCard_tt_FireEmblem and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11875306.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11875306.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c11875306.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11875306.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end 




