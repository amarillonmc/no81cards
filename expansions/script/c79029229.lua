--雷姆必拓·近卫干员-断崖
function c79029229.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa900),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_EARTH),2,2,true) 
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029229)
	e1:SetCondition(c79029229.tocon)
	e1:SetTarget(c79029229.totg)
	e1:SetOperation(c79029229.toop)
	c:RegisterEffect(e1)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c79029229.iop)
	c:RegisterEffect(e5)
end
function c79029229.tocon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79029229.totg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft1=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	local ct=math.min(ft1,ft2)
	if chk==0 then return ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	and Duel.IsPlayerCanSpecialSummonMonster(tp,79029234,0,0x4011,2000,0,1,RACE_CYBERSE,ATTRIBUTE_EARTH,POS_FACEUP)
	and Duel.IsPlayerCanSpecialSummonMonster(tp,79029234,0,0x4011,2000,0,1,RACE_CYBERSE,ATTRIBUTE_DARK,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct*2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct*2,0,0)
end
function c79029229.toop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	Debug.Message("装置，启动。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029229,0))   
	local ct=math.min(ft1,ft2)
	if ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,tp,79029234,0,0x4011,2000,0,1,RACE_CYBERSE,ATTRIBUTE_DARK,POS_FACEUP)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,79029234,0,0x4011,2000,0,1,RACE_CYBERSE,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then
		for i=1,ft2 do
		local x=Duel.CreateToken(tp,79029234)
		Duel.MoveToField(x,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	--self destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_ONFIELD)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c79029229.sdcon)
	x:RegisterEffect(e7)
		end
		for i=1,ft1 do
		x=Duel.CreateToken(tp,79029234)
		Duel.MoveToField(x,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	--self destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_ONFIELD)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c79029229.sdcon)
	x:RegisterEffect(e7)
	end
end
end
function c79029229.sdcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandler():GetOwner(),LOCATION_MZONE,0,1,nil,79029229)
end
function c79029229.ifil(c)
	return c:IsReleasable() and c:IsCode(79029234)
end
function c79029229.iop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c79029229.ifil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 then return end
	local f=g:RandomSelect(tp,1)
	local p=f:GetFirst():GetControler()
	Duel.Release(f,REASON_COST)
	local c=e:GetHandler()
	if p==tp then
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.FromCards(a,d)
	local tc=g:Filter(Card.IsControler,nil,tp):GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	tc:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetOperation(c79029229.damop)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3,tp)
	Debug.Message("进攻就是最好的护卫。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029229,1))   
	else
	Debug.Message("只有生死，无关胜负。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029229,2))   
	local l=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local tc=l:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(tc:GetAttack()/2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetValue(tc:GetDefense()/2)
	tc:RegisterEffect(e2)
	tc=l:GetNext()
	end
	end
end
function c79029229.damop(e,tp,eg,ep,ev,re,r,rp)
		Duel.ChangeBattleDamage(tp,0)
end
