--半魔的伯爵
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_HANDES+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e4=e1:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCondition(s.spcon2)
	c:RegisterEffect(e4)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(aux.NOT(s.descon))
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(s.descon)
	c:RegisterEffect(e3)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c)
		if not (c:IsControler(tp) and c:IsSetCard(0x3f50)) then return false end
		if c:IsLocation(LOCATION_ONFIELD) then
			return c:IsFaceup()
		end
		return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsFaceupEx()
	end,1,nil)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at and at:IsFaceupEx() and at:IsControler(tp) and at:IsSetCard(0x3f50)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.check_field(c)
	return c:IsFaceup() and c:IsSetCard(0x3f50)
end

function s.thfilter(c,tp)
	if not (c:IsSetCard(0x3f50) and c:IsAbleToHand() and c:IsFaceupEx()) then return false end	
	local hand_g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if c:IsLocation(LOCATION_DECK) then
		return hand_g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) or c:IsType(TYPE_MONSTER)
	elseif c:IsLocation(LOCATION_GRAVE) then
		return hand_g:IsExists(Card.IsType,1,nil,TYPE_SPELL) or c:IsType(TYPE_SPELL)
	elseif c:IsLocation(LOCATION_REMOVED) then
		return hand_g:IsExists(Card.IsType,1,nil,TYPE_TRAP) or c:IsType(TYPE_TRAP)
	end	
	return false
end

function s.get_loc(c)
	if c:IsLocation(LOCATION_DECK) then return 1
	elseif c:IsLocation(LOCATION_GRAVE) then return 2
	elseif c:IsLocation(LOCATION_REMOVED) then return 3
	else return 0 end
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(s.check_field,tp,LOCATION_ONFIELD,0,nil)
		local codes={}
		for tc in aux.Next(g) do
			local code=tc:GetCode()
			if not codes[code] then
				codes[code]=true
			end
		end		
		local count=0
		for _ in pairs(codes) do
			count=count+1
		end
		if count>=3 then
			local tg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,tp)
			if tg:GetCount()>0 then
				if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local sg=tg:Select(tp,1,1,nil)
					if sg:GetCount()>0 then
						local tc=sg:GetFirst()
						local loc=s.get_loc(tc)
						local discard_type=0
						if loc==1 then
							discard_type=TYPE_MONSTER
						elseif loc==2 then
							discard_type=TYPE_SPELL
						elseif loc==3 then
							discard_type=TYPE_TRAP
						end
						if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
							Duel.ConfirmCards(1-tp,tc)
							if discard_type~=0 then
								local hand=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
								local discard_g=hand:Filter(Card.IsType,nil,discard_type)								
								if discard_g:GetCount()>0 then
									Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
									local discard_sg=discard_g:Select(tp,1,1,nil)
									if discard_sg:GetCount()>0 then
										Duel.SendtoGrave(discard_sg,REASON_EFFECT+REASON_DISCARD)
									end
								else
									Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
								end
							end
						end
					end
				end
			end
		end
	end
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.thconfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.desonfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f50) and not c:IsCode(id)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	local typ=0
	if tc:IsType(TYPE_MONSTER) then typ=1
	elseif tc:IsType(TYPE_SPELL) then typ=2
	elseif tc:IsType(TYPE_TRAP) then typ=3 end
	e:SetLabel(typ)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local typ=e:GetLabel()
	if typ==1 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif typ==2 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	elseif typ==3 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local typ=e:GetLabel()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if typ==1 then
			Duel.Destroy(tc,REASON_EFFECT)
		elseif typ==2 then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		elseif typ==3 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end