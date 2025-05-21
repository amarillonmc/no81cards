--早说了是魔法吧
function c60158216.initial_effect(c)
	aux.AddCodeList(c,60158001,60158101)
	
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(60158216,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c60158216.handcon)
	c:RegisterEffect(e0)
	
	--1xg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60158216,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,60158216)
	e1:SetCondition(c60158216.e1con)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(c60158216.e1op)
	c:RegisterEffect(e1)
	
	--2xg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60158216,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,6018216)
	e2:SetCost(c60158216.e2cost)
	e2:SetTarget(c60158216.e2tg)
	e2:SetOperation(c60158216.e2op)
	c:RegisterEffect(e2)
	
end

	--act in hand
function c60158216.handconf(c)
	return c:IsFaceup() and c:IsOriginalCodeRule(60158001)
end
function c60158216.handcon(e)
	return Duel.IsExistingMatchingCard(c60158216.handconf,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

	--1xg
function c60158216.e1conf(c)
	return c:IsFaceup() and (c:IsCode(60158001) or c:IsType(TYPE_LINK))
end
function c60158216.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60158216.e1conf,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and rp==1-tp
end
function c60158216.e1tgf(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToRemove()
end
function c60158216.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60158216.e1tgf,rp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c60158216.e1opf(c)
	return c:IsFaceup() and c:IsOriginalCodeRule(60158001) 
end
function c60158216.e1opff(c)
	return c:IsFaceup() and aux.NegateAnyFilter(c) and c:IsAbleToRemove()
end
function c60158216.e1op(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c60158216.e1opop)
end
function c60158216.e1opopf(c,e,tp)
	return c:IsCode(60158001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and ((c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) or (c:IsFaceup() or c:IsFacedown()))
end
function c60158216.e1opop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60158216.e1tgf,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then return end
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local ct=og:GetSum(Card.GetLink)
		local c=e:GetHandler()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(60158216,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,2)
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c60158216.retcon)
		e1:SetOperation(c60158216.retop)
		Duel.RegisterEffect(e1,tp)
		if ct>=4 then
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
			local g2=Duel.GetMatchingGroup(c60158216.e1opopf,1-tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
			if g2:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(60158216,2)) then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
				local sg=g2:Select(1-tp,1,1,nil)
				Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c60158216.retfilter(c)
	return c:GetFlagEffect(60158216)~=0
end
function c60158216.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(c60158216.retfilter,1,nil)
end
function c60158216.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c60158216.retfilter,nil)
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
end

	--2xg
function c60158216.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,e:GetHandler())
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c60158216.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=e:GetHandler()
	local sccode=sc:GetCode()
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsPlayerCanSpecialSummonMonster(tp,sccode,0,TYPES_EFFECT_TRAP_MONSTER,1500,1500,2,RACE_MACHINE,ATTRIBUTE_WATER)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sc,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60158216.e2op(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetDescription(aux.Stringid(60158216,4))
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
	e2:SetValue(c60158216.lmlimit)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e2)
end
function c60158216.lmlimit(e,c)
	if not c then return false end
	return not (c:IsCode(60158001) or c:IsCode(60158101))
end