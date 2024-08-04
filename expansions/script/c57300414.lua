--pvz bt z 迪斯科僵尸
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	Zombie_Characteristics_EX(c,700)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.natkcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker():IsCode(id,id-1) then
		Duel.RegisterFlagEffect(Duel.GetAttacker():GetControler(),id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.natkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>0
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,57300413,0xc520,TYPES_TOKEN_MONSTER,600,2000,1,RACE_ZOMBIE,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) then return end
	local seq=c:GetSequence()
	if seq==5 or seq==6 then return end
	local zone=0
	if seq>0 then zone=zone|(1<<(seq-1)) end
	if seq<4 then zone=zone|(1<<(seq+1)) end
	local ss=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if ss>1 then
		local token1=Duel.CreateToken(tp,57300413)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetOperation(s.backop)
		token1:RegisterEffect(e1)
		local token2=Duel.CreateToken(tp,57300413)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetOperation(s.backop)
		token2:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	elseif ss>0 then
		local token=Duel.CreateToken(tp,57300413)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetOperation(s.backop)
		token:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	else
		return
	end
end
function s.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Exile(c,0)
end