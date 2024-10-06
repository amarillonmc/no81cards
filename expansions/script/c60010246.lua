--灭剑焰龙·双极模式β
function c60010246.initial_effect(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c60010246.splimit)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c60010246.drtg)
	e1:SetOperation(c60010246.drop)
	c:RegisterEffect(e1)
	--select
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c60010246.slcon)
	e2:SetOperation(c60010246.slop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c60010246.target)
	e4:SetOperation(c60010246.operation)
	c:RegisterEffect(e4)
	if not c60010246.check then
		c60010246.check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c60010246.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_MOVE)
		ge2:SetOperation(c60010246.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c60010246.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c60010246.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c60010246.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c60010246.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
function c60010246.damval(e,re,val,r,rp,rc)
	return 0
end
function c60010246.egfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsLocation(LOCATION_MZONE)
end
function c60010246.slcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010246.egfilter,1,nil,tp) and not eg:IsContains(e:GetHandler()) and e:GetHandler():GetFlagEffect(60002134)~=0
end
function c60010246.cfilter(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function c60010246.slop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c60010246.egfilter,nil,tp)
	local lg=g:Filter(c60010246.cfilter,nil)
	if #g==0 then return end
	if #lg==0 or Duel.SelectOption(tp,aux.Stringid(60010246,0),aux.Stringid(60010246,1))==1 then
		for tc in aux.Next(g) do
			--disable
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c60010246.discon)
			e1:SetOperation(c60010246.disop)
			tc:RegisterEffect(e1)
		end
	else
		for tc in aux.Next(lg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(500)
			tc:RegisterEffect(e1)
			Card.RegisterFlagEffect(tc,60002134,RESET_EVENT+RESETS_STANDARD,0,1) --card 
			Duel.RegisterFlagEffect(tp,60002134,RESET_PHASE+PHASE_END,0,1) --ply t turn
			Duel.RegisterFlagEffect(tp,60002135,RESET_PHASE+PHASE_END,0,1000) --ply fore
			if Duel.GetFlagEffect(tp,60002134)>=2 then 
				Duel.Draw(tp,1,REASON_EFFECT)
			end
			if Duel.GetFlagEffect(tp,60002134)>=4 then 
				Duel.Damage(1-tp,500,REASON_EFFECT)
				Duel.Recover(tp,500,REASON_EFFECT)
			end
		end
	end
end
function c60010246.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc,seq2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE~=0 and seq2>4 then return false end
	local seq1=aux.MZoneSequence(c:GetSequence())
	seq2=aux.MZoneSequence(seq2)
	return bit.band(loc,LOCATION_ONFIELD)~=0 and rp==1-tp and seq1==4-seq2
end
function c60010246.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60010246)
	Duel.NegateEffect(ev)
end
function c60010246.chkfilter(c)
	return c:GetFlagEffect(50010246)==0
end
function c60010246.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010246.chkfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(50010246,RESET_EVENT+0x7e0000,0,0)
		tc:RegisterFlagEffect(60010246,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c60010246.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function c60010246.filter(c)
	return c:GetFlagEffect(60010246)>0
end
function c60010246.ggfilter(c)
	return c:IsFacedown() or not c:IsDisabled()
end
function c60010246.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010246.filter,tp,0,LOCATION_ONFIELD,nil)
	local og=g:Filter(aux.NegateAnyFilter,nil)
	for tc in aux.Next(og) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
	local gg=g:Filter(c60010246.ggfilter,nil)
	if #gg>0 then
		Duel.SendtoGrave(gg,REASON_RULE)
	end
end
