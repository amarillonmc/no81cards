--启灵元神·踏春繁语
function c16372014.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,16372001,16372002,16372003,true,true)
	aux.AddContactFusionProcedure(c,c16372014.ffilter2,LOCATION_ONFIELD,LOCATION_ONFIELD,Duel.SendtoGrave,REASON_COST)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,16372014)
	e1:SetTarget(c16372014.settg)
	e1:SetOperation(c16372014.setop)
	c:RegisterEffect(e1)
	--setself
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,16372014+100)
	e2:SetCondition(c16372014.setscon)
	e2:SetTarget(c16372014.setstg)
	e2:SetOperation(c16372014.setsop)
	c:RegisterEffect(e2)
	--set2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c16372014.spellcon)
	e3:SetTarget(c16372014.settg2)
	e3:SetOperation(c16372014.setop2)
	c:RegisterEffect(e3)
end
function c16372014.ffilter2(c,fc)
	return c:IsAbleToGraveAsCost() and (c:IsControler(fc:GetControler()) or c:IsFaceup())
end
function c16372014.setfilter(c)
	return c:IsSetCard(0xdc1) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c16372014.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372014.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16372014,0))
	local tc1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16372014.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16372014,1))
	local tc2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16372014.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,tc1):GetFirst()
	if tc1 and tc2 then
		Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc1:RegisterEffect(e1)
		Duel.MoveToField(tc2,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc2:RegisterEffect(e2)
	end
end
function c16372014.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372014.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372014.setsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c16372014.spellcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372014.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)
		and Duel.IsExistingMatchingCard(c16372014.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c16372014.thfilter(c,code)
	return c:IsSetCard(0xdc1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(code)
end
function c16372014.setop2(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	local p=aux.SelectFromOptions(tp,{b1,aux.Stringid(16372000+1,5),tp},{b2,aux.Stringid(16372000+1,6),1-tp})
	if p~=nil then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16372014.setfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if tc then
			if Duel.MoveToField(tc,tp,p,LOCATION_SZONE,POS_FACEUP,true) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				tc:RegisterEffect(e1)
				local g=Duel.GetMatchingGroup(c16372014.thfilter,tp,LOCATION_DECK,0,nil,tc:GetCode())
				if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(16372014,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local sc=g:Select(tp,1,1,nil)
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sc)
				end
			end
		end
	end
end