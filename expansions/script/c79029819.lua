--逆元构造 绯耀
function c79029819.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3,c79029819.ovfilter,aux.Stringid(79029819,0),99,c79029819.xyzop)
	c:EnableReviveLimit()   
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029819,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79029819)
	e1:SetCondition(c79029819.thcon)
	e1:SetTarget(c79029819.thtg)
	e1:SetOperation(c79029819.thop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029819,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,09029819)
	e2:SetCost(c79029819.eqcost)
	e2:SetTarget(c79029819.eqtg)
	e2:SetOperation(c79029819.eqop)
	c:RegisterEffect(e2)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c79029819.eqcheck)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029819,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,19029819)
	e3:SetTarget(c79029819.sptg2)
	e3:SetOperation(c79029819.spop2)
	e3:SetLabelObject(e4)
	c:RegisterEffect(e3)
end
function c79029819.cfilter(c)
	return c:IsCode(79029817) and c:IsAbleToDeckAsCost()
end
function c79029819.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa991) and c:IsType(TYPE_XYZ)
end
function c79029819.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029819.cfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c79029819.cfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	Duel.SendtoDeck(tc,nil,2,REASON_COST)
end
function c79029819.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79029819.filter(c)
	return c:IsSetCard(0xa991)
		and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c79029819.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c79029819.filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c79029819.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c79029819.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		local bool_a=tc:IsAbleToGrave()
		local bool_b=tc:IsAbleToHand()
		local op=2
		if bool_a and bool_b then
			op=Duel.SelectOption(tp,aux.Stringid(79029819,2),aux.Stringid(79029819,3))
		elseif bool_a then
			op=Duel.SelectOption(tp,aux.Stringid(79029819,2))
		elseif bool_b then
			op=Duel.SelectOption(tp,aux.Stringid(79029819,3))+1
		end
		if op==0 then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)  
		elseif op==1 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029819.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029819.splimit(e,c)
	return not c:IsSetCard(0xa991) and c:IsLocation(LOCATION_EXTRA)
end
function c79029819.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029819.eqfilter(c)
	return c:IsSetCard(0xa991) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c79029819.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c79029819.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c79029819.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c79029819.eqfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c79029819.eqlimit)
			e1:SetLabelObject(c)
			g:GetFirst():RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(1000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e2)
		end
	end
end
function c79029819.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c79029819.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
	local g=e:GetHandler():GetEquipGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c79029819.spfilter2(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029819.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject():GetLabelObject()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g and g:IsExists(c79029819.spfilter2,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029819.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject():GetLabelObject() 
	local mg=g:Filter(c79029819.spfilter2,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	sg=mg:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end

