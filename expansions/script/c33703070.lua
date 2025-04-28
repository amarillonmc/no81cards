--除虫射日
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(s.con)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		s.activate(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetCondition(s.regcon)
		e1:SetOperation(s.regop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(id,1))
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetTargetRange(1,0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsPreviousLocation(LOCATION_ONFIELD) 
	and c:GetReasonPlayer()==1-tp
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil,tp)
	if #g==0 then return end
	Duel.Hint(HINT_CARD,0,id)
	local tg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local code=tc:GetOriginalCode()
		local sg1=Duel.GetMatchingGroup(s.namefilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_EXTRA,0,nil,code)
		if #sg1>0 then 
			tg:Merge(sg1)
		end
		local sg2=Duel.GetMatchingGroup(s.namefilter,1-tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_EXTRA,0,nil,code)
		if #sg2>0 then
			tg:Merge(sg2)
		end
	end
	local tg2=Group.CreateGroup()
	local dg1=tg:Filter(Card.IsControler,nil,tp)
	if tg and Duel.Destroy(dg1,REASON_EFFECT)~=0 then
		local og1=Duel.GetOperatedGroup()
		tg2:Merge(og1)
		cg=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
		Duel.ConfirmCards(tp,cg)
		Duel.BreakEffect()
		local dg2=tg:Filter(Card.IsControler,nil,1-tp)
		Duel.Destroy(dg2,REASON_EFFECT)
		local og2=Duel.GetOperatedGroup()
		tg2:Merge(og2)
	end
	if #tg2>0 then
		Duel.Recover(tp,#tg2*500,REASON_EFFECT)
	end
end
function s.namefilter(c,code)
	return c:IsCode(code) 
end