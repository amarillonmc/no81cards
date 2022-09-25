--深空 水神 沃特
function c72101206.initial_effect(c)
	c:SetUniqueOnField(1,1,72101206)

	--summon rlue
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72101206,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c72101206.tzcon)
	e1:SetOperation(c72101206.tzop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c72101206.setcon)
	c:RegisterEffect(e2)

	--health
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72101206,1))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c72101206.htar)
	e3:SetOperation(c72101206.hop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)

	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(72101206,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c72101206.seacost)
	e5:SetOperation(c72101206.seaop)
	c:RegisterEffect(e5)
	local e11=e5:Clone()
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetHintTiming(0,TIMING_BATTLE_END+TIMING_END_PHASE)
	e11:SetCondition(c72101206.searcon)
	c:RegisterEffect(e11)
	local e12=e5:Clone()
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetHintTiming(0,TIMING_BATTLE_END+TIMING_END_PHASE)
	e12:SetCost(c72101206.searccost)
	e12:SetCondition(c72101206.searccon)
	c:RegisterEffect(e12)

	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetRange(LOCATION_ONFIELD)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c72101206.indtg)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--avoid battle damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(c72101206.indtg)
	e7:SetValue(1)
	c:RegisterEffect(e7)

	--to grave
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(72101206,3))
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetCondition(c72101206.tgcon)
	e8:SetTarget(c72101206.tgtg)
	e8:SetOperation(c72101206.tgop)
	c:RegisterEffect(e8)

	--changdi zhaohuan bubei wuxiao
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(c72101206.cdval)
	c:RegisterEffect(e9)
	--changdi zhaohuan buneng fadong
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_SUMMON_SUCCESS)
	e10:SetCondition(c72101206.cdcon)
	e10:SetOperation(c72101206.cdop)
	c:RegisterEffect(e10)

end

--Summon rule
function c72101206.tzcon(e,c,minc)
	if c==nil then return true 
	end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c72101206.tzop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c72101206.setcon(e,c,minc)
	if not c then return true 
	end
	return false
end

--health
function c72101206.htar(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCounter(0,1,1,0x7210)
	if chk==0 then return ct>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*1000)
end
function c72101206.hop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCounter(0,1,1,0x7210)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if ct>0 then

		Duel.Recover(p,ct*1000,REASON_EFFECT)
	end
end

--search
	--1
function c72101206.seafilter(c)
	return c:IsSetCard(0xcea) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c72101206.gmnfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DIVINE)
end
function c72101206.seacost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ag=Duel.GetMatchingGroup(c72101206.gmnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	local bg=ag:GetCount()
	local cg=Duel.GetMatchingGroup(c72101206.seafilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local dg=cg:GetCount()
	local ct=Duel.GetCounter(0,1,1,0x7210)
	if chk==0 then 

		return Duel.IsCanRemoveCounter(tp,1,1,0x7210,1,REASON_COST) 
		and bg and dg 
	end
	local t={}
	local i=1
	if (bg>ct and dg>ct) or (dg>bg and bg==ct)  or (bg>dg and dg==ct)then

			for i=1,ct do t[i]=i end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
			e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
		elseif (ct>bg and dg>bg) or (ct>dg and bg==dg )  or (dg>ct and bg==ct ) then

			for i=1,bg do t[i]=i end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
			e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
		else

			for i=1,dg do t[i]=i end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
			e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	end
	local xg=e:GetLabel()
	if Duel.IsCanRemoveCounter(tp,1,1,0x7210,xg,REASON_COST) 
		and Duel.IsExistingMatchingCard(c72101206.seafilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,xg,nil)  then

		Duel.RemoveCounter(tp,1,1,0x7210,xg,REASON_COST)
	end
end
function c72101206.seaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local xg=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c72101206.seafilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,xg,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
	--2
function c72101206.searcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) and Duel.GetTurnPlayer()==tp
end
	--3
function c72101206.searccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local gg=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return gg:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 
	end
	Duel.Remove(gg,POS_FACEDOWN,REASON_COST)
	local ag=Duel.GetMatchingGroup(c72101206.gmnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	local bg=ag:GetCount()
	local cg=Duel.GetMatchingGroup(c72101206.seafilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local dg=cg:GetCount()
	local ct=Duel.GetCounter(0,1,1,0x7210)
	if chk==0 then 

		return Duel.IsCanRemoveCounter(tp,1,1,0x7210,1,REASON_COST) 
		and bg and dg 
	end
	local t={}
	local i=1
	if (bg>ct and dg>ct) or (dg>bg and bg==ct)  or (bg>dg and dg==ct)then

			for i=1,ct do t[i]=i end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
			e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
		elseif (ct>bg and dg>bg) or (ct>dg and bg==dg )  or (dg>ct and bg==ct ) then

			for i=1,bg do t[i]=i end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
			e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
		else

			for i=1,dg do t[i]=i end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
			e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	end
	local xg=e:GetLabel()
	if Duel.IsCanRemoveCounter(tp,1,1,0x7210,xg,REASON_COST) 
		and Duel.IsExistingMatchingCard(c72101206.seafilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,xg,nil)  then

		Duel.RemoveCounter(tp,1,1,0x7210,xg,REASON_COST)
	end
end
function c72101206.searccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) and not (Duel.GetTurnPlayer()==tp)
end

--indes
function c72101206.indtg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DIVINE)
end

--to grave
function c72101206.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c72101206.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c72101206.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

--changdi zhaohuan bubei wuxiao
function c72101206.cdval(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end
--changdi zhaohuan chenggong bufadong
function c72101206.cdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,72101207) 
end
function c72101206.genchainlm(c)
	return  function (e,rp,tp)
				return e:GetHandler():IsSetCard(0xcea)
			end
end
function c72101206.cdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c72101206.genchainlm(e:GetHandler()))
end
