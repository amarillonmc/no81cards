--咏叹调歌姬 睦月
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--limit summons
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(s.lsop)
	c:RegisterEffect(e1)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		record_tab2={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(s.spcon)
		ge1:SetOperation(s.spop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.lsop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0xaa70)
end
function s.spfilter(c,tp)
	local flag=false
	local chain=Duel.GetCurrentChain()
	for i=1,chain do
		local re,rp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if rp==tp and re:GetHandler():IsSetCard(0xca70) then
			flag=true
		end 
	end
	return flag and (c:IsOriginalCodeRule(id) or c:IsHasEffect(id)) 
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,c)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.spfilter,re:GetHandlerPlayer(),LOCATION_EXTRA,0,1,nil,re:GetHandlerPlayer())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local p=re:GetHandlerPlayer()
	if Duel.SelectYesNo(p,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(p,s.spfilter,p,LOCATION_EXTRA,0,1,1,nil,p)
		if #sg>0 then
			local tc=sg:GetFirst()
			Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEUP)
			local e2=Effect.CreateEffect(tc)
			e2:SetDescription(aux.Stringid(id,0))
			e2:SetType(EFFECT_TYPE_QUICK_F)
			e2:SetCode(id)
			e2:SetReset(RESET_EVENT+RESET_TODECK)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(s.op)
			tc:RegisterEffect(e2)
			Duel.RaiseEvent(eg,id,re,r,rp,ep,ev)
		end
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetCondition(s.discon)
	e3:SetOperation(s.disop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetTargetRange(1,1)
	Duel.RegisterEffect(e4,tp)
end
function s.costtg(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	c:CreateEffectRelation(te)
end
function s.checkintab(tab,v)
	for _,ve in ipairs(tab) do
		if ve==v then
			return true
		end
	end
	return false
end
function s.discon(e)
	for tp=0,1 do
		if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_TO_HAND) then
			local effect_record={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_TO_HAND)}
			for _,ke in ipairs(effect_record) do
				if not s.checkintab(record_tab2,ke) then
					return true
				end
			end
		end
	end
	return false
end
function s.disop(e)
	for tp=0,1 do
		if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_TO_HAND) then
			local effect_record={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_TO_HAND)}
			for _,ke in ipairs(effect_record) do
				if not s.checkintab(record_tab2,ke) then
					local condition=ke:GetCondition() or aux.TRUE
					ke:SetCondition(function(...)
									   return not Duel.IsPlayerAffectedByEffect(0,id) and condition(...)
									end)
					table.insert(record_tab2,ke)
				end
			end
		end
	end
end
function s.thfilter(c)
	return c:IsSetCard(0xca70) and c:IsAbleToHand() and c:IsFaceupEx()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) 
	and e:GetHandler():IsLocation(LOCATION_MZONE) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end