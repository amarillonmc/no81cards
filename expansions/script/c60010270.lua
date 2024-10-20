--蜃市万华
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010261)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon1)
	e1:SetTarget(cm.thtg1)
	e1:SetOperation(cm.thop1)
	c:RegisterEffect(e1)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCondition(cm.sumcon)
	e4:SetTarget(cm.sumtg)
	e4:SetOperation(cm.sumop)
	c:RegisterEffect(e4)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(cm.smcost)
	e3:SetTarget(cm.smtg)
	e3:SetOperation(cm.smop)
	c:RegisterEffect(e3)
end
function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.bsfil1(c)
	return c:IsCode(60010262) and c:IsFaceup()
end
function cm.bsfil2(c)
	return c:IsCode(60010265) and c:IsFaceup()
end
function cm.fil1(c)
	return c:IsFaceup()
end
function cm.fil2(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)~=0 then
		local t=0
		if Duel.IsExistingMatchingCard(cm.bsfil1,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,cm.bsfil1,tp,LOCATION_SZONE,0,1,1,nil)
			if dg and Duel.Destroy(dg,REASON_EFFECT)~=0 then
				t=t+1
				local ug=Duel.GetMatchingGroup(cm.fil1,tp,LOCATION_MZONE,0,nil)
				for uc in aux.Next(ug) do 
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(1000)
					uc:RegisterEffect(e1)
				end
			end
		end
		if Duel.IsExistingMatchingCard(cm.bsfil2,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,7)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,cm.bsfil2,tp,LOCATION_SZONE,0,1,1,nil)
			if dg and Duel.Destroy(dg,REASON_EFFECT)~=0 then
				t=t+1
				local ug=Duel.GetMatchingGroup(cm.fil2,tp,LOCATION_MZONE,0,nil)
				for uc in aux.Next(ug) do 
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_DEFENSE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(1000)
					uc:RegisterEffect(e1)
				end
			end
		end
		if t~=0 then Duel.Draw(tp,1,REASON_EFFECT) end
	end
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_PUBLIC)
	e11:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e11)
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH,ATTRIBUTE_FIRE,ATTRIBUTE_WATER,ATTRIBUTE_WIND)
end
function cm.tgfil(c,sc)
	return c:IsAbleToGrave() and c:IsCanBeRitualMaterial(sc) and c:IsRace(RACE_ILLUSION)
end
function cm.attrfil(c)
	return c:GetAttribute()~=0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for tc in aux.Next(eg) do
		if tc:IsAttribute(ATTRIBUTE_FIRE) and c:GetFlagEffect(60010262)==0 then 
			c:RegisterFlagEffect(60010262,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
		end
		if tc:IsAttribute(ATTRIBUTE_WATER) and c:GetFlagEffect(60010263)==0 then 
			c:RegisterFlagEffect(60010263,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
		end
		if tc:IsAttribute(ATTRIBUTE_WIND) and c:GetFlagEffect(60010264)==0 then 
			c:RegisterFlagEffect(60010264,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
		end
		if tc:IsAttribute(ATTRIBUTE_EARTH) and c:GetFlagEffect(60010265)==0 then 
			c:RegisterFlagEffect(60010265,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
		end
	end
	if c:GetFlagEffect(60010262)~=0 and c:GetFlagEffect(60010263)~=0 and c:GetFlagEffect(60010264)~=0 and c:GetFlagEffect(60010265)~=0 and Duel.IsExistingMatchingCard(cm.tgfil,tp,LOCATION_DECK,0,c:GetLevel(),nil,c) and c:GetLevel()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,cm.tgfil,tp,LOCATION_DECK,0,c:GetLevel(),c:GetLevel(),nil,c)
		if Duel.SendtoGrave(g,REASON_EFFECT)==c:GetLevel() then
			c:SetMaterial(g)
			local gg=g:Filter(cm.attrfil,nil)
			local ec=gg:GetFirst()
			if #gg>1 then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				ec=gg:Select(tp,1,1,nil):GetFirst()
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetRange(0xff)
			e1:SetValue(ec:GetAttribute())
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e1)
			Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
			c:CompleteProcedure()
		end
	end
end

function cm.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function cm.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.smop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	local op=aux.SelectFromOptions(tp,{true,aux.Stringid(m,8)},{true,aux.Stringid(m,9)},{true,aux.Stringid(m,10)},{true,aux.Stringid(m,11)})
	local code=60010261+op
	local token=Duel.CreateToken(tp,code)
	if Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,60010261))
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end



