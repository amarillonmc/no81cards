local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,s.sfilter,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.chcon)
	e1:SetOperation(s.chop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_MSET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCondition(s.descon)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(s.descon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.adjustop1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MSET)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		ge4:SetOperation(s.check)
		Duel.RegisterEffect(ge4,0)
	end
end
s.material_type=TYPE_SYNCHRO
function s.sfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsSynchroType(TYPE_SYNCHRO)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg:Filter(Card.IsFacedown,nil)) do tc:RegisterFlagEffect(id,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1,e:GetCode()) end
end
function s.checkfil(c)
	return c:GetFlagEffect(id)>0 and c:IsFacedown()
end
function s.adjustop1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	local g2=g1:Filter(s.checkfil,nil)
	if e:GetHandler():IsDisabled() then g1:ForEach(Card.SetStatus,0x0100,true) else
		g2:ForEach(Card.SetStatus,0x0100,false)
		Group.__sub(g1,g2):ForEach(Card.SetStatus,0x0100,true)
	end
end
function s.check(e,tp,eg,ep,ev,re,r,rp)
	eg:GetFirst():RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetFlagEffect(id+500)==0
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		Duel.DisableShuffleCheck()
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then Duel.ConfirmCards(1-tp,c) end
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
