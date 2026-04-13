--心象风景死寂
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,19209511)
	--①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)
	
	--②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(3,id)
	e2:SetCondition(s.effcon)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end

function s.searchfilter(c)
	return c:IsCode(19209511) and c:IsAbleToHand()
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.searchfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function s.cfilter(c,tp)
	return c:IsSetCard(0x3b50) and c:IsType(TYPE_MONSTER) and c:IsPreviousControler(tp)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.thfilter(c)
	return c:IsSetCard(0xb51) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end

function s.pzfilter(c,tp)
	if not c:IsControler(tp) then return false end
	local is_faceup_extra = c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
	local is_onfield = c:IsLocation(LOCATION_ONFIELD) and not c:IsLocation(LOCATION_PZONE)
	if not (is_faceup_extra or is_onfield) then return false end
	if not c:IsType(TYPE_PENDULUM) then return false end
	return c:IsAbleToRemove() or (not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)))
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1 = c:IsDestructable() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2 = Duel.IsExistingMatchingCard(s.pzfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,nil,tp)
	
	if chk==0 then return c:GetFlagEffect(id)==0 and (b1 or b2) end
	
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
	end
	e:SetLabel(op)
	
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_EXTRA)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	if op==0 then
		if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				local b1=tc:IsAbleToHand()
				local b2=tc:IsSSetable()
				local opt=0
				
				if b1 and b2 then
					opt=Duel.SelectOption(tp,1190,1153)
				elseif b1 then
					opt=0
				else
					opt=1
				end
				
				if opt==0 then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				else
					Duel.SSet(tp,tc)
				end
			end
		end
	else

		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,s.pzfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			local b1=not tc:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
			local b2=tc:IsAbleToRemove()
			local opt=0
			
			if b1 and b2 then
				opt=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5))
			elseif b1 then
				opt=0
			else
				opt=1
			end
			
			if opt==0 then
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			else
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end