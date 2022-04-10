--圣赐乐土 见行者
function c79083102.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79083102+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c79083102.hspcon)
	e1:SetValue(c79083102.hspval)
	e1:SetOperation(c79083102.hspop)
	c:RegisterEffect(e1)
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,19083102)
	e2:SetTarget(c79083102.thtg)
	e2:SetOperation(c79083102.thop)
	c:RegisterEffect(e2)
end
c79083102.named_with_Laterano=true 
function c79083102.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local flag=0 
	if Duel.IsPlayerAffectedByEffect(tp,79083110) then 
	flag=bit.bor(flag,1) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083210) then 
	flag=bit.bor(flag,2) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083310) then 
	flag=bit.bor(flag,4) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083410) then 
	flag=bit.bor(flag,8) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083510) then 
	flag=bit.bor(flag,16) 
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,flag)>0
end
function c79083102.hspval(e,c)
	local tp=c:GetControler()
	local flag=0 
	if Duel.IsPlayerAffectedByEffect(tp,79083110) then 
	flag=bit.bor(flag,1) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083210) then 
	flag=bit.bor(flag,2) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083310) then 
	flag=bit.bor(flag,4) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083410) then 
	flag=bit.bor(flag,8) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083510) then 
	flag=bit.bor(flag,16) 
	end
	return SUMMON_TYPE_RITUAL,flag 
end
function c79083102.hspop(e,tp,eg,ep,ev,re,r,rp,c) 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79083102,1)) 
	Duel.Hint(24,0,aux.Stringid(79083102,2)) 
end
function c79083102.thfil(c)
	return c:IsAbleToHand() and c.named_with_Laterano 
end
function c79083102.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c79083102.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79083102.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79083102.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()<=0 then return end 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	local xp=0 
	if Duel.IsPlayerAffectedByEffect(tp,79083110) and c:GetSequence()==0 then 
	xp=1  
	elseif Duel.IsPlayerAffectedByEffect(tp,79083210) and c:GetSequence()==1 then 
	xp=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79083310) and c:GetSequence()==2 then 
	xp=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79083410) and c:GetSequence()==3 then 
	xp=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79083510) and c:GetSequence()==4 then 
	xp=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79084110) and c:GetSequence()==5 then 
	xp=1  
	elseif Duel.IsPlayerAffectedByEffect(tp,79084210) and c:GetSequence()==6 then 
	xp=1 
	end 
	if xp==1 and tc:GetActivateEffect()~=nil and tc:GetActivateEffect():IsActivatable(tp) and tc:CheckActivateEffect(false,false,false)~=nil 
	and Duel.SelectYesNo(tp,aux.Stringid(79083102,0)) then 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79083102,3)) 
	Duel.Hint(24,0,aux.Stringid(79083102,4)) 
		local te,te1=tc:GetActivateEffect()
		local tep=tc:GetControler()
		if te==nil then return end  
		if tc:IsType(TYPE_FIELD) then 
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)  
		else 
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)  
		end  
		local op=0
		if te1~=nil and te1:IsActivatable(tp) then 
		op=Duel.SelectOption(tp,te:GetDescription(),te1:GetDescription())
		end 
		if op and op==1 then te=te1 end 
			local condition=te:GetCondition()
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
				and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
				and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
				Duel.ClearTargetCard()
				e:SetProperty(te:GetProperty())
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				if tc:IsType(TYPE_CONTINUOUS+TYPE_FIELD) or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then 
				else  
				tc:CancelToGrave(false)
				end
				tc:CreateEffectRelation(te)
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				if target then target(te,tep,eg,ep,ev,re,r,rp,1) end 
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) 
				if g~=nil then 
				local tg=g:GetFirst()
				while tg do
					tg:CreateEffectRelation(te)
					tg=g:GetNext()
				end
				end
				if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(te)
				if g~=nil then 
				tg=g:GetFirst()
				while tg do
					tg:ReleaseEffectRelation(te)
					tg=g:GetNext()
				end
				end
			else
				Duel.Destroy(tc,REASON_EFFECT)
			end 
	else
	Duel.SendtoHand(tc,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,tc)
	end
end






