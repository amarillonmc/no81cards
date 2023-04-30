--夏乡追忆 彼端自赎
function c67210105.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67210105,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c67210105.con)
	e4:SetTarget(c67210105.tg)
	e4:SetOperation(c67210105.op)
	c:RegisterEffect(e4)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67210105,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+67210105)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCountLimit(1,67210105)
	e2:SetCondition(c67210105.spcon)
	e2:SetTarget(c67210105.sptg)
	e2:SetOperation(c67210105.spop)
	c:RegisterEffect(e2)  
	if not c67210105.global_check then
		c67210105.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c67210105.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_DESTROYED)
		ge2:SetCondition(c67210105.regcon)
		ge2:SetOperation(c67210105.regop)
		Duel.RegisterEffect(ge2,0)
	end  
end
--
function c67210105.con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE
end
function c67210105.penfilter(c)
	return c:IsSetCard(0x367e) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and not c:IsCode(67210105)
end
function c67210105.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:GetFirst():IsAbleToHand() and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c67210105.penfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,0)
end
function c67210105.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local emp=Group.CreateGroup()
	emp:AddCard(c)
	emp:Merge(eg)
	if Duel.SendtoHand(emp,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c67210105.penfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
--
function c67210105.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			tc:RegisterFlagEffect(67210105,RESET_EVENT+0x1f20000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsLocation(LOCATION_EXTRA) then
			tc:RegisterFlagEffect(67210105,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c67210105.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c67210105.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(c67210105.spcfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c67210105.spcfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c67210105.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+67210105,re,r,rp,ep,e:GetLabel())
end
---
function c67210105.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==PLAYER_ALL
end
function c67210105.filter11(c)
	return c:IsSetCard(0x67e) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and not c:IsCode(67210105)
end
function c67210105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and eg:IsExists(c67210105.filter11,1,nil) and eg:GetCount()>1 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,eg:GetCount()-1,0,0)
	
end
function c67210105.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if eg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=eg:FilterSelect(tp,c67210105.filter11,1,1,nil)
			local tc=sg:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			local emp=Group.CreateGroup()
			emp:Merge(eg)
			if eg:GetCount()>1 then
				emp:RemoveCard(tc)
				Duel.SendtoHand(emp,nil,REASON_EFFECT)
			end
		end
	end
end



