--战械人形 M4A1
function c29065600.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,29065600)
	e1:SetTarget(c29065600.eqtg)
	e1:SetOperation(c29065600.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065600,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29000023)
	e3:SetTarget(c29065600.rettg)
	e3:SetOperation(c29065600.retop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c29065600.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
   
end
function c29065600.eqfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c29065600.thfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x87ad) and not c:IsCode(29065600)
end
function c29065600.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065600.eqfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c29065600.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29065600.eqfil,tp,LOCATION_HAND,0,nil)
	if g:GetCount()<=0 then return end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if Duel.Equip(tp,tc,c) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c29065600.eqlimit)
			tc:RegisterEffect(e1)
	local g1=Duel.GetMatchingGroup(c29065600.thfil,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29065600,0)) then
	local hg=g1:Select(tp,1,1,nil)
	Duel.SendtoHand(hg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,hg)
	end
   end
end

function c29065600.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsSetCard(0x87ad)  
end
function c29065600.exqfil(c) 
	return c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c29065600.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c29065600.exqfil,tp,0,LOCATION_MZONE,1,nil) end
	local g=nil 
	if c:IsType(TYPE_XYZ) then
	g=Duel.SelectTarget(tp,c29065600.exqfil,tp,0,LOCATION_MZONE,1,2,nil)
	else
	g=Duel.SelectTarget(tp,c29065600.exqfil,tp,0,LOCATION_MZONE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
end
function c29065600.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
	local tc=tg:GetFirst()
	while tc do
	Duel.Equip(tp,tc,c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c29065600.eqlimit)
			tc:RegisterEffect(e1)
	tc=tg:GetNext()
	end
	end
end
function c29065600.eqlimit(e,c)
	return e:GetOwner()==c 
end


