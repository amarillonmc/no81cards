--秘异三变体异变侵食
function c69164878.initial_effect(c)
	--adjust
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(c69164878.adjustop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69164878,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,69164878)
	e1:SetTarget(c69164878.target)
	e1:SetOperation(c69164878.activate)
	c:RegisterEffect(e1)
end
function c69164878.thfilter(c,tp,check)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x157) and c:IsAbleToHand()
end
function c69164878.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69164878.thfilter,tp,LOCATION_DECK,0,1,nil,tp,true) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c69164878.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c69164878.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp,true)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.RegisterFlagEffect(tp,69164879,RESET_PHASE+PHASE_END,0,1)
	end
end

----------------effect gain---------------

function c69164878.filter(c)
	return c:IsSetCard(0x157) and c:IsType(TYPE_MONSTER)
end
function c69164878.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not c69164878.globle_check then
		c69164878.globle_check=true
		local g=Duel.GetMatchingGroup(c69164878.filter,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil)
		cregister=Card.RegisterEffect
		table_effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				table.insert(table_effect,eff)
			end
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(69164878,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				local cost=eff:GetCost()
				if cost then
					if tc:GetOriginalCode()==6182103 then
						eff:SetCost(c69164878.negcost)
					elseif tc:GetOriginalCode()==26561172 then
						eff:SetCost(c69164878.spcost)
					elseif tc:GetOriginalCode()==43709490 then
						eff:SetCost(c69164878.sp2cost)
					elseif tc:GetOriginalLevel()<=4 then
						eff:SetCost(c69164878.spcost2)
					elseif tc:GetOriginalCode()==7574904 then
						eff:SetCost(c69164878.rmcost)
					else
						eff:SetCost(c69164878.cost)
					end
				end
				cregister(tc,eff)
			end
		end
		Card.RegisterEffect=cregister
	end
	e:Reset()
end

--level 10
function c69164878.cfilter(c,rtype,tp)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsAbleToRemoveAsCost()
		and (not c:IsOnField() or c:IsFaceup())
		and c:IsType(rtype) and ((c:IsSetCard(0x157) and c:IsControler(tp)) or (Duel.GetFlagEffect(tp,69164879)~=0 and c:IsControler(1-tp) and Duel.GetFlagEffect(tp,69164878)==0))
end
function c69164878.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=re:GetActiveType()&0x7
	if chk==0 then return Duel.IsExistingMatchingCard(c69164878.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,rtype,tp) end
	local g=Duel.SelectMatchingCard(tp,c69164878.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,rtype,tp)
	if g:GetFirst():GetControler()~=tp then
		Duel.Hint(HINT_CARD,0,69164878)
		Duel.RegisterFlagEffect(tp,69164878,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--level 1
function c69164878.spcostexcheckfilter(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(code)
end
function c69164878.spcostexcheck(c,e,tp)
	local result=false
	if c:GetOriginalType()&TYPE_MONSTER~=0 then
		result=result or Duel.IsExistingMatchingCard(c26561172.spcostexcheckfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,e,tp,34695290)
	end
	if c:GetOriginalType()&TYPE_SPELL~=0 then
		result=result or Duel.IsExistingMatchingCard(c26561172.spcostexcheckfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,e,tp,61089209)
	end
	if c:GetOriginalType()&TYPE_TRAP~=0 then
		result=result or Duel.IsExistingMatchingCard(c26561172.spcostexcheckfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,e,tp,7574904)
	end
	return result
end
function c69164878.spcostfilter(c,e,tp)
	return c:IsAbleToRemoveAsCost() and ((c:IsSetCard(0x157) and c:IsControler(tp)) or (Duel.GetFlagEffect(tp,69164879)~=0 and c:IsControler(1-tp) and c:IsFaceup() and Duel.GetFlagEffect(tp,69164878)==0)) and c69164878.spcostexcheck(c,e,tp) 
end
function c69164878.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		return Duel.IsExistingMatchingCard(c69164878.spcostfilter,tp,LOCATION_HAND+LOCATION_DECK,LOCATION_ONFIELD,1,nil,e,tp)
			and e:GetHandler():IsReleasable() and Duel.GetMZoneCount(tp,e:GetHandler())>0
	end
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cost=Duel.SelectMatchingCard(tp,c69164878.spcostfilter,tp,LOCATION_HAND+LOCATION_DECK,LOCATION_ONFIELD,1,1,nil,e,tp):GetFirst()
	e:SetLabel(cost:GetOriginalType())
	if cost:GetControler()~=tp then
		Duel.Hint(HINT_CARD,0,69164878)
		Duel.RegisterFlagEffect(tp,69164878,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
end

--level 4
function c69164878.sp2costfilter(c,tp,tc)
	local tg=Group.FromCards(c,tc)
	return c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and (c:IsControler(tp) or (Duel.GetFlagEffect(tp,69164879)~=0 and c:IsControler(1-tp) and Duel.GetFlagEffect(tp,69164878)==0))
		and Duel.GetMZoneCount(tp,tg)>0
end
function c69164878.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable()
		and Duel.IsExistingMatchingCard(c69164878.sp2costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp,c) end
	Duel.Release(c,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cost=Duel.SelectMatchingCard(tp,c69164878.sp2costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,tp,c)
	if cost:GetControler()~=tp then
		Duel.Hint(HINT_CARD,0,69164878)
		Duel.RegisterFlagEffect(tp,69164878,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
end

--level2,3
function c69164878.spcostfilter2(c,e,tp,tc)
	local tg=Group.FromCards(c,tc)
	return c:IsAbleToRemoveAsCost() and c69164878.spcostexcheck(c,e,tp)
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and (c:IsControler(tp) or (Duel.GetFlagEffect(tp,69164879)~=0 and c:IsControler(1-tp) and Duel.GetFlagEffect(tp,69164878)==0))
		and Duel.GetMZoneCount(tp,tg)>0
end
function c69164878.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		return Duel.IsExistingMatchingCard(c69164878.spcostfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),e,tp,e:GetHandler())
			and e:GetHandler():IsReleasable()
	end
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cost=Duel.SelectMatchingCard(tp,c69164878.spcostfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),e,tp,e:GetHandler()):GetFirst()
	e:SetLabel(cost:GetOriginalType())
	if cost:GetControler()~=tp then
		Duel.Hint(HINT_CARD,0,69164878)
		Duel.RegisterFlagEffect(tp,69164878,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
end

--Arsenal
function c69164878.rmtgfilter(c,e)
	return c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function c69164878.rmcostfilter(c,e,tp)
	return c:IsAbleToRemoveAsCost() and (c:IsControler(tp) or (Duel.GetFlagEffect(tp,69164879)~=0 and c:IsControler(1-tp) and c:IsFaceup() and Duel.GetFlagEffect(tp,69164878)==0)) and Duel.IsExistingMatchingCard(c69164878.rmtgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,e)
end
function c69164878.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69164878.rmcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c69164878.rmcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	if g:GetFirst():GetControler()~=tp then
		Duel.Hint(HINT_CARD,0,69164878)
		Duel.RegisterFlagEffect(tp,69164878,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

--
function c69164878.costfilter(c,e,tp)
	return c:IsAbleToRemoveAsCost() and (c:IsControler(tp) or (Duel.GetFlagEffect(tp,69164879)~=0 and c:IsControler(1-tp) and c:IsFaceup() and Duel.GetFlagEffect(tp,69164878)==0))
end
function c69164878.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69164878.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c69164878.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
	if g:GetFirst():GetControler()~=tp then
		Duel.Hint(HINT_CARD,0,69164878)
		Duel.RegisterFlagEffect(tp,69164878,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
