--[[
水晶魔法小妖精 洁米
Gémi, The Crystal Magic
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[When an opponent's monster declares an attack: You can banish this card from your hand or field;
	Special Summon up to 2 "Extension Tokens" (Psychic/WATER/Level 3). Their ATK/DEF become equal to the ATK/DEF of the attacking monster.
	If you control no monsters when this effect resolves, you can Special Summon up to 5 "Extension Token" instead.
	While any of these Tokens is in a Monster Zone, the player who Summoned it cannot Special Summon.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND|LOCATION_MZONE)
	e1:SetCondition(function(_,tp) return Duel.GetAttacker():IsControler(1-tp) end)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.tktg)
	e1:SetOperation(s.tkop)
	c:RegisterEffect(e1)
	--During the End Phase (Quick Effect): You can place this banished card on the top of your Deck, face up.
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCondition(aux.EndPhaseCond())
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	--While this card is face-up on the top of your Deck, Tokens you control cannot be destroyed by battle or card effects, also they gain ATK/DEF equal to half your LP.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_DECK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(s.econ)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOKEN))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(s.atkval)
	c:RegisterEffect(e5)
	e5:UpdateDefenseClone(c)
end
--E1
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if chk==0 then
		local atk,def=a:GetAttack(),a:GetDefense()
		local exc=e:IsCostChecked() and c or nil
		return Duel.GetMZoneCount(tp,exc)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33720084,0,TYPES_TOKEN_MONSTER,atk,def,3,RACE_PSYCHO,ATTRIBUTE_WATER)
	end
	Duel.SetTargetCard(a)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and 1 or Duel.GetMZoneCount(tp)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,33720084,0,TYPES_TOKEN_MONSTER,atk,def,3,RACE_PSYCHO,ATTRIBUTE_WATER) then return end
	local c=e:GetHandler()
	local a=Duel.GetFirstTarget()
	local atk,def
	if a:IsRelateToChain() and a:IsRelateToBattle() and a==Duel.GetAttacker() and a:IsFaceup() then
		atk,def=a:GetAttack(),a:GetDefense()
	end
	local max=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and 5 or 2
	local n=Duel.AnnounceNumberMinMax(tp,1,math.min(ft,max))
	for i=1,n do
		local token=Duel.CreateToken(tp,33720084)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_TOFIELD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(def)
		token:RegisterEffect(e2,true)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetRange(LOCATION_MZONE)
			e3:SetAbsoluteRange(tp,1,0)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD)
			token:RegisterEffect(e3,true)
		end
	end
	Duel.SpecialSummonComplete()
end

--E2
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:HasFlagEffect(id) and c:IsAbleToDeck() end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetCardOperationInfo(c,CATEGORY_TODECK)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
		c:ReverseInDeck()
	end
end

--E3
function s.econ(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:GetSequence()==Duel.GetDeckCount(e:GetHandlerPlayer())-1
end
function s.atkval(e,c)
	return Duel.GetLP(e:GetHandlerPlayer())/2
end