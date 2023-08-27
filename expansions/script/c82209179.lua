--童话动物·小小独角兽
local m=82209179
local cm=c82209179
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon limit
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)  
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetCondition(cm.thcon2)
	c:RegisterEffect(e4)
end

--splimit
function cm.splimit(e,se)
	return se and se:GetHandler()==e:GetHandler()
end

--spsummon
function cm.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x146)
		and c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c)>0
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,true,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,true,POS_FACEUP)
	end
end

--to hand
function cm.cfilter(c,sp)
	return c:GetSummonPlayer()==sp
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND)
		and Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local og=Group.CreateGroup()
		while tc do
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 and tc:IsLocation(LOCATION_REMOVED) then
				tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				og:AddCard(tc)   
			end
			tc=g:GetNext()
		end
		if og:GetCount()>0 then
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)  
			e1:SetDescription(aux.Stringid(m,3))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
			e1:SetCode(EVENT_PHASE+PHASE_END)  
			e1:SetReset(RESET_PHASE+PHASE_END)  
			e1:SetLabelObject(og)  
			e1:SetCountLimit(1)  
			e1:SetCondition(cm.retcon)  
			e1:SetOperation(cm.retop)  
			Duel.RegisterEffect(e1,tp) 
		end
	end
end
function cm.retfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsReason(REASON_TEMPORARY) and c:GetFlagEffect(m)>0
end
function cm.retcheck(c,sg)
	return not sg:IsContains(c)
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)  
	local og=e:GetLabelObject()
	return og:FilterCount(cm.retfilter,nil)>0
end  
function cm.retop(e,tp,eg,ep,ev,re,r,rp)  
	local og=e:GetLabelObject():Filter(cm.retfilter,nil)
	local rg1=og:Filter(Card.IsPreviousControler,nil,tp)
	local rg2=og:Filter(Card.IsPreviousControler,nil,1-tp)
	local rg=Group.CreateGroup()
	local tg=Group.CreateGroup()
	local loc1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)

	if rg1:GetCount()>loc1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		local sg1=rg1:Select(tp,loc1,loc1,nil)
		tg:Merge(rg1:Filter(cm.retcheck,nil,sg1))
		rg1=sg1
	end

	if rg2:GetCount()>loc2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(m,4))
		local sg2=rg2:Select(1-tp,loc2,loc2,nil)
		tg:Merge(rg2:Filter(cm.retcheck,nil,sg2))
		rg2=sg2
	end

	rg:Merge(rg1)
	rg:Merge(rg2)

	if rg:GetCount()>0 then
		local rc=rg:GetFirst() 
		while rc do
			Duel.ReturnToField(rc)
			rc=rg:GetNext()
		end
	end

	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		while tc do
			Duel.ReturnToField(tc)
			tc=tg:GetNext()
		end
	end
end  