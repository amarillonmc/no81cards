--GAH-Fairy Marker, Hoover
--Scripted by:XGlitchy30
local id=33720038
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--redirect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e1)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UNION_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.eqtg)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)
	--boost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(200)
	local e4x=e4:Clone()
	e4x:SetCode(EFFECT_UPDATE_DEFENSE)
	--search limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1,0)
	e6:SetTarget(s.sctg)
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_TO_HAND)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.stcon)
	e7:SetTarget(s.sttg)
	e7:SetOperation(s.stop)
	--grant
	local gr1=Effect.CreateEffect(c)
	gr1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	gr1:SetRange(LOCATION_SZONE)
	gr1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	gr1:SetTarget(s.eftg)
	gr1:SetLabelObject(e4)
	c:RegisterEffect(gr1)
	local gr2=gr1:Clone()
	gr2:SetLabelObject(e4x)
	c:RegisterEffect(gr2)
	local gr4=gr1:Clone()
	gr4:SetLabelObject(e6)
	c:RegisterEffect(gr4)
	local gr5=gr1:Clone()
	gr5:SetLabelObject(e7)
	c:RegisterEffect(gr5)
end
function s.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and ct2==0
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or (c:IsOnField() and c:IsFacedown()) then return end
	if not tc:IsRelateToEffect(e) or not s.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc) then return end
	aux.SetUnionState(c)
end
--
function s.eftg(e,c)
	return c:GetEquipGroup():IsContains(e:GetHandler())
end
--
function s.sctg(e,c,tp,re)
	return c:IsLocation(LOCATION_DECK) and (not re or (re:GetHandler() and re:GetHandler()~=e:GetHandler()))
end
--
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler()==tp and c:IsLocation(LOCATION_HAND)
end
function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp)
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.scfilter(c,tp,og)
	local typ0=c:GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	return c:IsAbleToHand() and og:IsExists(s.gcheck,1,nil,tp,typ0)
end
function s.gcheck(c,tp,typ)
	return c:IsType(typ) and (Duel.GetFlagEffect(tp,id)<=0 or Duel.GetFlagEffectLabel(tp,id)&typ==0)
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil,1-tp)
	if #g>0 then
		local og=g:Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsControler,nil,1-tp)
		Duel.ConfirmCards(tp,og)
		local typ0=g:GetFirst():GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		if Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_DECK,0,1,nil,tp,og) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,s.scfilter,tp,LOCATION_DECK,0,1,1,nil,tp,og)
			if #sg>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
				local hg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsControler,nil,tp)
				if #hg==0 then return end
				Duel.ConfirmCards(1-tp,hg)
				local typ=hg:GetFirst():GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
				if Duel.GetFlagEffect(tp,id)<=0 then
					Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
					Duel.SetFlagEffectLabel(tp,id,0)
				end
				Duel.SetFlagEffectLabel(tp,id,Duel.GetFlagEffectLabel(tp,id)+typ)
			end
		end
	end
end