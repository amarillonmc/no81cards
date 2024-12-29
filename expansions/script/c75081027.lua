--永生结界
function c75081027.initial_effect(c)
	--to deck
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c75081027.optg)
	e0:SetOperation(c75081027.opop)
	c:RegisterEffect(e0)  
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75081027,3))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c75081027.discon)
	e3:SetOperation(c75081027.disop)
	c:RegisterEffect(e3)  
end
function c75081027.spfilter(c,e,tp)
	return c:IsCode(75081025,75081026) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c75081027.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75081027.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,75081027)==0
	local b2=Duel.GetFlagEffect(tp,75081028)==0
	if chk==0 then return b1 or b2 end
end
function c75081027.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75081027.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,75081027)==0
	local b2=Duel.GetFlagEffect(tp,75081028)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(75081027,1),aux.Stringid(75081027,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(75081027,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(75081027,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75081027.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,75081027,RESET_PHASE+PHASE_END,0,1)
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTarget(c75081027.indtg)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterFlagEffect(tp,75081028,RESET_PHASE+PHASE_END,0,1)
	end
end
function c75081027.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
--
function c75081027.disfilter(c)
	return c:IsAbleToRemove()
end
function c75081027.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c75081027.disfilter,tp,LOCATION_HAND,0,1,nil)
		and e:GetHandler():GetFlagEffect(75081028)<=0
end
function c75081027.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if g1:GetCount()>0 and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(75081027,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,c75081027.disfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) then
			local fid=c:GetFieldID()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(tc)
			e1:SetCondition(c75081027.retcon)
			e1:SetOperation(c75081027.retop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			tc:RegisterFlagEffect(75081027,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			Duel.Hint(HINT_CARD,0,75081027)
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)
			Duel.ChangeChainOperation(ev,c75081027.repop)
			e:GetHandler():RegisterFlagEffect(75081028,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75081027,5))
		end
	end
end
function c75081027.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c75081027.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75081027)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c75081027.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end