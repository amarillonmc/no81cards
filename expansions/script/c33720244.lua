--[[
空羽 亚乃亚 - Black Viper
Aoba Anoa - Black Viper
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableReviveLimit()
	--[[When this card is Special Summoned: You can pay LP in multiples of 1000 (max. 3000); for each 1000 LP you paid, choose 1 of the following effects for this card to gain:]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetFunctions(nil,aux.DummyCost,s.target,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:IsCostChecked() and Duel.CheckLPCost(tp,1000)
	end
	local ct=math.min(3,Duel.GetLP(tp)//1000)
	local t={}
	for i=1,ct do
		t[i]=i*1000
	end
	local cost=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,cost)
	Duel.SetTargetParam(math.floor(cost/1000))
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local cost=Duel.GetTargetParam()
	if not cost or cost==0 then return end
	local opt=0
	if cost==3 then
		opt=0x7
	else
		for i=1,cost do
			local b1=opt&0x1==0
			local b2=opt&0x2==0
			local b3=opt&0x4==0
			local choice=aux.Option(tp,id,1,b1,b2,b3)
			opt=opt|(1<<choice)
		end
	end
	if opt==0 then return end
	local c=e:GetHandler()
	if opt&0x1==0x1 then
		--[[You can pay 800 LP; Special Summon 1 "Option Token". Its Type, Attribute, Level, ATK and DEF are always the same as this card,
		but it leaves the field if this card is no longer face-up on the field.]]
		local e1=Effect.CreateEffect(c)
		e1:Desc(1,id)
		e1:SetCategory(CATEGORIES_TOKEN)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetFunctions(nil,aux.PayLPCost(800),s.tktg,s.tkop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	if opt&0x2==0x2 then
		--[[Once per Battle Phase (Quick Effect): You can pay 1000 LP; double the ATK of this card until the end of this turn, also, for the rest of this turn,
		any battle damage your opponent takes from battles involving your "Option Tokens" is doubled]]
		local e2=Effect.CreateEffect(c)
		e2:Desc(2,id)
		e2:SetCategory(CATEGORY_ATKCHANGE)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_MZONE)
		e2:SetRelevantBattleTimings()
		e2:SetFunctions(s.atkcon,aux.PayLPCost(1000),s.atktg,s.atkop)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
	if opt&0x4==0x4 then
		--[[Once per turn (Quick Effect): You can pay 2000 LP; equip as many Equip Spells as possible from your GY to this card.]]
		local e3=Effect.CreateEffect(c)
		e3:Desc(3,id)
		e3:SetCategory(CATEGORY_EQUIP)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetRange(LOCATION_MZONE)
		e3:SetRelevantTimings()
		e3:SetFunctions(nil,aux.PayLPCost(2000),s.eqtg,s.eqop)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e3)
	end
end

--E1.1
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToChain() or c:IsFacedown() then return end
	local atk=c:GetAttack()
	local def=c:GetDefense()
	local lv=c:GetLevel()
	local race=c:GetRace()
	local att=c:GetAttribute()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,TYPES_TOKEN_MONSTER,atk,def,lv,race,att) then return end
	local token=Duel.CreateToken(tp,93130022)
	c:CreateRelation(token,RESET_EVENT|RESETS_STANDARD)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE,EFFECT_FLAG2_OPTION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.tokenatk)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_TOFIELD)
	token:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetValue(s.tokendef)
	token:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(s.tokenlv)
	e3:SetReset(RESET_EVENT|RESETS_STANDARD_TOFIELD)
	token:RegisterEffect(e3,true)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(s.tokenrace)
	e4:SetReset(RESET_EVENT|RESETS_STANDARD_TOFIELD)
	token:RegisterEffect(e4,true)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(s.tokenatt)
	e5:SetReset(RESET_EVENT|RESETS_STANDARD_TOFIELD)
	token:RegisterEffect(e5,true)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.tokendescon)
	e6:SetOperation(s.tokendesop)
	e6:SetReset(RESET_EVENT|RESETS_STANDARD_TOFIELD)
	token:RegisterEffect(e6,true)
	Duel.SpecialSummonComplete()
end
function s.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function s.tokendef(e,c)
	return e:GetOwner():GetDefense()
end
function s.tokenlv(e,c)
	return e:GetOwner():GetLevel()
end
function s.tokenrace(e,c)
	return e:GetOwner():GetRace()
end
function s.tokenatt(e,c)
	return e:GetOwner():GetAttribute()
end
function s.tokendescon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetOwner():IsRelateToCard(e:GetHandler())
end
function s.tokendesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Exile(e:GetHandler(),REASON_RULE)
end

--E1.2
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase() and aux.ExceptOnDamageCalc()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:HasFlagEffect(id)
	end
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE,0,1)
	Duel.SetCustomOperationInfo(0,CATEGORY_ATKCHANGE,c,1,0,0,{c:GetAttack()*2})
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_DISABLE|RESET_PHASE|PHASE_END)
		c:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,93130022))
	e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	e2:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

--E1.3
function s.eqfilter(c,ec,tp)
	return c:IsSpell(TYPE_EQUIP) and c:CheckEquipTarget(ec) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil,c,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or not c:IsFaceup() then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local eq=Duel.GetMatchingGroup(s.eqfilter,tp,LOCATION_GRAVE,0,nil,c,tp)
	if ft>#eq then ft=#eq end
	if ft==0 then return end
	for i=1,ft do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local ec=eq:Select(tp,1,1,nil):GetFirst()
		eq:RemoveCard(ec)
		Duel.Equip(tp,ec,c,true,true)
	end
	Duel.EquipComplete()
end