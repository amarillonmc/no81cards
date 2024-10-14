--魔女术组合·召唤小组
function c98920499.initial_effect(c)
	c:SetSPSummonOnce(98920499)
	--link summon
	aux.AddLinkProcedure(c,c98920499.mfilter,2,2,c98920499.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920499,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98930499)
	e1:SetCost(c98920499.cost)
	e1:SetCondition(c98920499.cond)
	e1:SetTarget(c98920499.target)
	e1:SetOperation(c98920499.operation)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(98920499)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920499.cond)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(c98920499.adjustop)
	c:RegisterEffect(e01)
	if not c98920499.global_activate_check then
		c98920499.global_activate_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c98920499.checkop)
		Duel.RegisterEffect(ge1,0)
	end	
end
function c98920499.mfilter(c) 
	return c:IsLinkRace(RACE_SPELLCASTER)   
end 
function c98920499.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c98920499.cond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCode(98920499)
end
function c98920499.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:GetValue()~=98942051 then return end
	if rc:IsLocation(LOCATION_MZONE) and rc:GetFlagEffect(98920499)==0 then
		rc:RegisterFlagEffect(98920499,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c98920499.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return ((te:GetValue()==98920500) and not Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),98920499)) or ((te:GetValue()==98920499) and Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),98920499))
end
function c98920499.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not c98920499.globle_check then
		local c=e:GetHandler()
		--change effect type
		--
		c98920499.globle_check=true
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(c98920499.actarget)
		Duel.RegisterEffect(ge0,0)
		local g=Duel.GetMatchingGroup(c98920499.aafilter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		ecreateeffect=Effect.CreateEffect
		esetcountLimit=Effect.SetCountLimit
		table_effect={}
		table_countlimit_flag=0
		table_countlimit_count=0
		Effect.SetCountLimit=function(effect,count,flag)
			table_countlimit_flag=flag
			table_countlimit_count=count
			return esetcountLimit(effect,count,flag)
		end
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				local cost=eff:GetCost()
				if cost and effect:IsHasType(EFFECT_TYPE_QUICK_O) and effect:GetCode()==EVENT_FREE_CHAIN  then
					eff:SetValue(98920499)
					--effect edit
					local eff2=effect:Clone()
					eff2:SetValue(98920500)
					eff2:SetDescription(aux.Stringid(98920499,0))
					--spell speed 2
					if cost and eff2:IsHasType(EFFECT_TYPE_QUICK_O) and eff2:GetCode()==EVENT_FREE_CHAIN then
						eff2:SetCost(c98920499.acost)
					end
					table.insert(table_effect,eff2)
				end
				table.insert(table_effect,eff)
			end
			table_countlimit_flag=0
			table_countlimit_count=0
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(98920499,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
		end
		Card.RegisterEffect=cregister
		Effect.CreateEffect=ecreateeffect
		Effect.SetCountLimit=esetcountLimit
	end
	e:Reset()
end
function c98920499.aafilter(c)
	return not c:IsCode(98920499) and c:IsSetCard(0x128) and c:IsType(TYPE_MONSTER)
end
function c98920499.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsType(TYPE_SPELL) and c:IsDiscardable() end
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsHasEffect(83289866,tp)
end
function c98920499.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920499.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c98920499.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local te=tc:IsHasEffect(83289866,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.SendtoGrave(tc,REASON_COST)
	else
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function c98920499.filter(c,e,tp)
	return c:IsSetCard(0x128) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920499.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920499.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920499.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920499.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		g:GetFirst():RegisterEffect(e1)
	end
end
function c98920499.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsType(TYPE_SPELL) and c:IsDiscardable() end
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsHasEffect(83289866,tp)
end
function c98920499.deckcostfilter(c,tp)
	return c:IsSetCard(0x128) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c98920499.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920499.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,tp) or (Duel.IsExistingMatchingCard(c98920499.deckcostfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetFlagEffect(tp,36562627)==0) end
	if Duel.IsExistingMatchingCard(c98920499.deckcostfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetFlagEffect(tp,98920500)==0 and (not Duel.IsExistingMatchingCard(c98920499.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,tp) or Duel.SelectYesNo(tp,aux.Stringid(98920499,1))) then
		 local g=Duel.GetMatchingGroup(c98920499.deckcostfilter,tp,LOCATION_DECK,0,nil,tp)
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		 local tc=g:Select(tp,1,1,nil):GetFirst()
		 Duel.Hint(HINT_CARD,0,98920499)
		 Duel.RegisterFlagEffect(tp,98920500,RESET_PHASE+PHASE_END,0,1)
		 if e:GetHandler():IsLevelBelow(4) then Duel.Release(e:GetHandler(),REASON_COST) end
		 Duel.SendtoGrave(tc,REASON_COST)
	else
		local g=Duel.GetMatchingGroup(c98920499.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local te=tc:IsHasEffect(83289866,tp)
		if te then
		   te:UseCountLimit(tp)
		   Duel.SendtoGrave(tc,REASON_COST)
		else
			Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
		end
		if e:GetHandler():IsLevelBelow(4) then Duel.Release(e:GetHandler(),REASON_COST) end
	end
end