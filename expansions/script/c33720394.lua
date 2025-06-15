--[[
化心为甲
Heart As Armor
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[At the start of the Battle Phase: You can send this card from your hand to the GY, then target up to 5 face-up cards equipped to 1 monster you control; for each of those cards, replace its effects with 1 of the following, until the end of your next turn (for this effect's resolution, you can only choose each of the following effects once).]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE|PHASE_BATTLE_START)
	e1:SetRange(LOCATION_HAND)
	e1:OPT()
	e1:SetFunctions(nil,aux.ToGraveSelfCost,s.target,s.activate)
	c:RegisterEffect(e1)
	--If the equipped monster attacks, your opponent cannot activate cards or effects until the end of the Damage Step.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(aux.AND(s.condition(1),aux.IsEquippedCond))
	e2:SetOperation(s.lmop)
	c:RegisterEffect(e2)
	--If the equipped monster destroys a monster by battle, inflict damage to your opponent equal to the ATK the destroyed monster had on field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(aux.AND(s.condition(2),aux.IsEquippedCond,s.bdcon))
	e3:SetOperation(s.bdop)
	c:RegisterEffect(e3)
	--The equipped monster gains 500 ATK/DEF for each Spell/Trap you control.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(s.condition(3))
	e4:SetValue(s.value)
	c:RegisterEffect(e4)
	e4:UpdateDefenseClone(c)
	--The equipped monster gains ATK equal to the difference between the players' LP.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetCondition(s.condition(4))
	e5:SetValue(s.lpval)
	c:RegisterEffect(e5)
	--If the equipped monster battles your opponent's monster, during damage calculation: The equipped monster's original ATK/DEF become equal to the ATK or DEF (whichever is higher) of the opponent's battling monster +100, during damage calculation only
	local e6=Effect.CreateEffect(c)
	e6:Desc(5,id)
	e6:SetCategory(CATEGORY_ATKCHANGE|CATEGORY_DEFCHANGE)
	e6:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(aux.AND(s.condition(5),s.atkcon))
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6)
end
function s.condition(label)
	return	function(e)
				return e:GetHandler():HasFlagEffectLabel(id,label)
			end
end

--E1
function s.filter(c,e,tp)
	return c:IsFaceup() and c:GetEquipTarget() and c:GetEquipTarget():IsControler(tp)
end
function s.rescon(g,e,tp,mg,c)
    local ec=c:GetEquipTarget()
    local razor = {function(_c) return _c:GetEquipTarget()==ec end}
    return true,false,razor
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsFaceup() and chkc:GetEquipTarget() and chkc:GetEquipTarget():IsControler(tp) end
	if chk==0 then
		return Duel.IsExists(true,s.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,tp)
	end
	local g=Duel.Group(s.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,tp):Filter(Card.IsCanBeEffectTarget,nil,e)
	local tg=xgl.SelectUnselectGroup(0,g,e,tp,1,5,s.rescon,1,tp,HINTMSG_TARGET)
	Duel.SetTargetCard(tg)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards()
	if #g==0 then return end
	local resets=RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END|RESET_SELF_TURN
	local rct=Duel.GetNextPhaseCount(false,tp)
	local options={true,true,true,true,true}
	while #g>0 do
		Duel.HintMessage(tp,aux.Stringid(id,6))
		local tg=g:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		local op=aux.Option(tp,id,1,table.unpack(options))+1
		options[op]=false
		tc:RegisterFlagEffect(id,resets,EFFECT_FLAG_CLIENT_HINT,rct,op,aux.Stringid(id,op))
		local eset={tc:IsHasEffect(EFFECT_EQUIP_LIMIT)}
		tc:ReplaceEffect(id,resets,rct)
		for _,ce in ipairs(eset) do
			if ce:IsHasProperty(EFFECT_FLAG_INITIAL) then
				local clone=ce:Clone()
				clone:SetReset(RESET_EVENT|RESETS_STANDARD)
				tc:RegisterEffect(clone)
			end
		end
		g:RemoveCard(tc)
	end
end

--E2
function s.lmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetAttacker()~=c:GetEquipTarget() then return end
	Duel.Hint(HINT_CARD,tp,c:GetOriginalCode())
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE|PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end

--E3
function s.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc==e:GetHandler():GetEquipTarget()
end
function s.bdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetOriginalCode())
	Duel.Damage(1-tp,eg:GetFirst():GetBattleTarget():GetPreviousAttackOnField(),REASON_EFFECT)
end

--E4
function s.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSpellTrapOnField,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*500
end

--E5
function s.lpval(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end

--E6
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()
	return ec and tc and tc:IsFaceup() and tc:IsControler(1-tp)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()
	if ec and tc and ec:IsFaceup() and tc:IsFaceup() then
		local val=math.max(tc:GetAttack(),tc:GetDefense())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK_FINAL)
		e1:SetValue(val+100)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE_CAL)
		ec:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
		ec:RegisterEffect(e2)
	end
end