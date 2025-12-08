local s,id=GetID()
Duel.LoadScript("kcode_myxyz.lua")
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTarget(s.tgtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end

s.nightmare_setcode = my  -- 梦魇

function s.thfilter(c)
	return c:IsSetCard(s.nightmare_setcode) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then
		
		if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end

function s.eqfilter(c)
	return c:IsFaceup() and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,s.nightmare_setcode)
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
	if chk==0 then
		return Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.eqfilter2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local eqg=tc:GetEquipGroup():Filter(Card.IsSetCard,nil,s.nightmare_setcode)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eqg,eqg:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,eqg:GetCount(),tp,LOCATION_DECK)
	end
end

function s.eqfilter2(c)
	return c:IsSetCard(s.nightmare_setcode) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	
	local eqg=tc:GetEquipGroup():Filter(Card.IsSetCard,nil,s.nightmare_setcode)
	local ct=eqg:GetCount()
	if ct==0 then return end
	
	if Duel.SendtoGrave(eqg,REASON_EFFECT)~=0 then

		local g=Duel.GetMatchingGroup(s.eqfilter2,tp,LOCATION_DECK,0,nil)
		if #g<ct then ct=#g end
		
		if ct>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=ct then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=g:Select(tp,ct,ct,nil)
			for ec in aux.Next(sg) do
				if Duel.Equip(tp,ec,tc,true,false) then
					
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(s.eqlimit)
					ec:RegisterEffect(e1)
				end
			end
			Duel.EquipComplete()
		end
	end
end

-- 装备限制
function s.eqlimit(e,c)
	return true
end

function s.tgtg(e,c)
	return c:IsSetCard(s.nightmare_setcode) and c:GetType()==TYPE_EQUIP
end