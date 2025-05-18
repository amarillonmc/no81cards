--我有一个大胆的想法
function c60158215.initial_effect(c)
	aux.AddCodeList(c,60158001,60158101)
	
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(60158215,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c60158215.handcon)
	c:RegisterEffect(e0)
	
	--1xg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60158215,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,60158215)
	e1:SetCondition(c60158215.e1con)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(c60158215.e1op)
	c:RegisterEffect(e1)
	
	--2xg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60158215,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,6018215)
	e2:SetCost(c60158215.e2cost)
	e2:SetTarget(c60158215.e2tg)
	e2:SetOperation(c60158215.e2op)
	c:RegisterEffect(e2)
end

	--act in hand
function c60158215.handconf(c)
	return c:IsFaceup() and c:IsOriginalCodeRule(60158001)
end
function c60158215.handcon(e)
	return Duel.IsExistingMatchingCard(c60158215.handconf,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

	--1xg
function c60158215.e1conf(c)
	return c:IsFaceup() and (c:IsCode(60158001) or c:IsType(TYPE_LINK))
end
function c60158215.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60158215.e1conf,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsChainNegatable(ev)
		and ep==1-tp
end
function c60158215.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c60158215.e1opf(c)
	return c:IsFaceup() and c:IsOriginalCodeRule(60158001) 
end
function c60158215.e1opff(c)
	return c:IsFaceup() and aux.NegateAnyFilter(c) and c:IsAbleToRemove()
end
function c60158215.e1op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
	if Duel.IsExistingMatchingCard(c60158215.e1opf,tp,LOCATION_MZONE,0,1,nil) then
		local g=Duel.GetMatchingGroup(c60158215.e1opff,tp,0,LOCATION_EXTRA+LOCATION_GRAVE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60158215,2)) then
			Duel.BreakEffect()
			local dam=Duel.GetCurrentChain()
			if dam>=g:GetCount() then dam=g:GetCount() end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=g:Select(tp,1,dam,nil)
			local tc=sg:GetFirst()
			while tc do
				if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
					local c=e:GetHandler()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TRAPMONSTER) then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e3)
					end
					Duel.AdjustInstantly()
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				end
				tc=sg:GetNext()
			end
		end
	end
end

	--2xg
function c60158215.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,e:GetHandler())
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c60158215.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=e:GetHandler()
	local sccode=sc:GetCode()
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsPlayerCanSpecialSummonMonster(tp,sccode,0,TYPES_EFFECT_TRAP_MONSTER,1500,1500,2,RACE_MACHINE,ATTRIBUTE_WATER)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sc,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60158215.e2op(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetHandler()
	local sccode=sc:GetCode()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,sccode,0,TYPES_EFFECT_TRAP_MONSTER,1500,1500,2,RACE_MACHINE,ATTRIBUTE_WATER) then return end
	if not (sc:IsLocation(LOCATION_GRAVE) or (sc:IsLocation(LOCATION_REMOVED) and sc:IsFaceup())) then return end
	if sc:IsType(TYPE_SPELL) then 
		sc:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL,ATTRIBUTE_WATER,RACE_MACHINE,2,1500,1500) 
	elseif sc:IsType(TYPE_TRAP) then
		sc:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP,ATTRIBUTE_WATER,RACE_MACHINE,2,1500,1500)
	else
		return false 
	end
	sc:CancelToGrave()
	Duel.SpecialSummon(sc,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(60158215,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(60158101)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e1)
	--cannot link material
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetValue(c60158215.lmlimit)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e2)
end
function c60158215.lmlimit(e,c)
	if not c then return false end
	return not (c:IsCode(60158001) or c:IsCode(60158101))
end