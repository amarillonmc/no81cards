--终极铠甲·帝皇铠甲
function c9981518.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),5,true)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.fuslimit)
	c:RegisterEffect(e3)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9981518)
	e2:SetCondition(c9981518.descon)
	e2:SetTarget(c9981518.destg)
	e2:SetOperation(c9981518.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c9981518.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9981518.efilter)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c9981518.actcon)
	e3:SetValue(c9981518.actlimit)
	c:RegisterEffect(e3)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c9981518.atkcon)
	e3:SetCost(c9981518.atkcost)
	e3:SetOperation(c9981518.atkop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981518.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981518.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981518,0))
end
function c9981518.valcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsRace,nil,RACE_WARRIOR)
	if g:GetClassCount(Card.GetCode)==5 then e:GetLabelObject():SetLabel(1) end
end
function c9981518.descon(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	return t>s
end
function c9981518.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,t-s) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(t-s)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,t-s)
end
function c9981518.desop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local t=Duel.GetFieldGroupCount(p,0,LOCATION_HAND+LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(p,LOCATION_HAND+LOCATION_ONFIELD,0)
	if t>s then
		Duel.Draw(p,t-s,REASON_EFFECT)
	end
end
function c9981518.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9981518.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c9981518.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c9981518.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and bc:GetAttack()>0
end
function c9981518.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(9981518)==0 end
	c:RegisterFlagEffect(9981518,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c9981518.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981518,1))
end