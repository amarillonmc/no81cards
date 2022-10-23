--深空 暗
function c72101222.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c72101222.sprcon)
	e1:SetTarget(c72101222.sprtg)
	e1:SetOperation(c72101222.sprop)
	c:RegisterEffect(e1)

	--special summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c72101222.spsusop)
	c:RegisterEffect(e2)

	--public
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72101222,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1)
	e3:SetCondition(c72101222.pubcon)
	e3:SetOperation(c72101222.pubop)
	c:RegisterEffect(e3)

	--special summon quick
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72101222,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,72101222)
	e4:SetCondition(c72101222.spcon)
	e4:SetTarget(c72101222.sptg)
	e4:SetOperation(c72101222.spop)
	c:RegisterEffect(e4)
	
	--cannot special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e5)

end

--special summon
function c72101222.sprfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c72101222.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and (g:GetClassCount(Card.GetAttribute)==#g	 or g:GetClassCount(Card.GetRace)==#g)
end
function c72101222.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c72101222.sprfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return rg:CheckSubGroup(c72101222.fselect,3,3,tp)
end
function c72101222.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(c72101222.sprfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=rg:SelectSubGroup(tp,c72101222.fselect,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c72101222.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end

--special summon success
function c72101222.spsusop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72101222.pcfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_CARD,0,72101222)
	if #g>0 then
		if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 
			and Duel.IsExistingMatchingCard(c72101222.czfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) then
			Duel.Draw(tp,#g,REASON_EFFECT)
		end
	end
end
function c72101222.pcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanTurnSet()
end

--public
function c72101222.czfilter(c)
	return c:IsCode(72101215) and (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
		or c:IsLocation(LOCATION_GRAVE))
end
function c72101222.pubcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) 
		and Duel.IsExistingMatchingCard(c72101222.czfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c72101222.pubop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(72101222,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e1)
end

--special summon quick
function c72101222.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) 
		and Duel.GetTurnPlayer()~=tp
		and c:IsPublic()
end
function c72101222.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c72101222.spop(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c=e:GetHandler()
	if c and Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP) then
		local fid=e:GetHandler():GetFieldID()
		c:RegisterFlagEffect(72101222,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(c72101222.thcon)
		e1:SetOperation(c72101222.thop)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SpecialSummonComplete()
end
function c72101222.thcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=1-tp then return false end
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(72101222)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c72101222.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end