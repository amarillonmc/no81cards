--鲜虾蒸蛋料理
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11637004,11637007)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_ANNOUNCE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMINGS_CHECK_MONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.imtg)
	e4:SetOperation(s.imop)
	c:RegisterEffect(e4)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(s.checkop3)
		Duel.RegisterEffect(ge2,0)
	end
end

s.FoodMaterial_Listed={11637004,11637007}

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	Duel.RegisterFlagEffect(0,id,RESET_CHAIN,0,1,tc:GetCode())
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsSetCard(0x9221) then
			Duel.RegisterFlagEffect(0,81,RESET_CHAIN,0,1)
		end
	end
end
function s.checkop3(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsSetCard(0xa221) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(rp,id+1,0,0,0)
	end
end

function s.label_check(...)
	local labels={...}
	local flag1=false
	local flag2=false
	if labels then 
		for i = 0, #labels do 
			if labels[i]==11637004 then flag1=true end
			if labels[i]==11637007 then flag2=true end
		end
	end
	return flag1 and flag2
end
function s.splimit(e,se,sp,st)
	return s.label_check(Duel.GetFlagEffectLabel(0,id)) and se:GetHandler():IsSetCard(0xa221) and Duel.GetFlagEffect(0,81)==0
end

function s.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local code=Duel.AnnounceCard(tp)
	e:SetLabel(code)
end
function s.imop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetLabel(code)
	e2:SetTarget(s.immune)
	e2:SetValue(s.efilter)
	Duel.RegisterEffect(e2,tp)
end
function s.immune(e,c)
	return c:IsSetCard(0x9221) and c:IsType(TYPE_FUSION)
end
function s.efilter(e,re)
	local code=e:GetLabel()
	return re:GetHandler():IsCode(code)
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()==1-tp
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetFlagEffect(tp,id+1)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local dg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(num*(-300))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end