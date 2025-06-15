--[[动物朋友 夏之赤龙
Anifriends Red Dragon of Summer
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
Duel.LoadScript("glitchylib_helper.lua")
Duel.LoadScript("glitchylib_player_counters.lua")
function s.initial_effect(c)
	PLAYER_COUNTERS_TABLE[PLAYER_COUNTER_HEAT] = {id,8}
	aux.SpawnGlitchyHelper(GLITCHY_HELPER_PLAYER_COUNTER_FLAG)
	
	c:EnableReviveLimit()
	--2+ monsters with ATK different from their original ATK
	aux.AddFusionProcFunRep2(c,s.ffilter,2,127,true)
	--[[If you have less LP than your opponent does, you can Special Summon this card (from your Extra Deck) by returning the above cards you control to your hand. (This is treated as a Fusion Summon).]]
	aux.AddContactFusionProcedureGlitchy(c,aux.Stringid(id,0),false,nil,Card.IsAbleToHandAsCost,LOCATION_MZONE,0,{s.cfcon,0},aux.ContactFusionMaterialsToHand)
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetLabel(0)
	e0:SetValue(s.matcheck)
	c:RegisterEffect(e0)
	--Gains 200 ATK for each Heat Counter on each player.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--[[If this card is Fusion Summoned: Place, on each player, a number of Heat Counters equal to the total difference between the ATK and the original ATK each Fusion Material had on field, divided by 100.]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCustomCategory(CATEGORY_PLAYER_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetLabelObject(e0)
	e2:SetFunctions(
		aux.FusionSummonedCond,
		nil,
		s.cttg,
		s.ctop
	)
	c:RegisterEffect(e2)
	--[[Before damage calculation, if this card attacks: Place, on 1 player, a number of Heat Counters equal to the total number of Heat Counters on each player, instead of doing damage calculation.]]
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCustomCategory(CATEGORY_PLAYER_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetFunctions(
		s.dmcon,
		nil,
		s.dmtg,
		s.dmop
	)
	c:RegisterEffect(e3)
	
	--The following effects apply to the current Duel once this card enters the field, and even after this card leaves the field (but if another "Anifriends Red Dragon of Summer" enters the field later on during this Duel, these effects will not be applied again).
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(s.effop)
	c:RegisterEffect(e4)
end
function s.ffilter(c,fc)
	return c:GetAttack()~=c:GetBaseAttack()
end
function s.cfcon(e,fc,tp,mg)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end

--E0
function s.matcheck(e,c)
	local val=0
	local g=c:GetMaterial()
	for tc in aux.Next(g) do
		val=val+math.floor(math.abs(tc:GetAttack()-tc:GetBaseAttack())/100)
	end
	e:SetLabel(val)
end

--E1
function s.atkval(e,c)
	return (Duel.GetPlayerCounterCount(0,PLAYER_COUNTER_HEAT) + Duel.GetPlayerCounterCount(1,PLAYER_COUNTER_HEAT)) * 200
end

--E2
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=e:GetLabelObject():GetLabel()
	Duel.SetTargetParam(val)
	Duel.SetCustomOperationInfo(0,CATEGORY_PLAYER_COUNTER,nil,val,PLAYER_ALL,PLAYER_COUNTER_HEAT)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetTargetParam()
	for p in aux.TurnPlayers() do
		Duel.AddPlayerCounter(p,PLAYER_COUNTER_HEAT,val,e,tp,REASON_EFFECT)
	end
end
	
--E3
function s.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function s.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=Duel.GetPlayerCounterCount(0,PLAYER_COUNTER_HEAT)+Duel.GetPlayerCounterCount(1,PLAYER_COUNTER_HEAT)
	Duel.SetCustomOperationInfo(0,CATEGORY_PLAYER_COUNTER,nil,val,PLAYER_NONE,PLAYER_COUNTER_HEAT)
end
function s.dmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToBattle() and not c:IsStatus(STATUS_ATTACK_CANCELED) then
		c:SetStatus(STATUS_ATTACK_CANCELED,true)
		local val=Duel.GetPlayerCounterCount(0,PLAYER_COUNTER_HEAT)+Duel.GetPlayerCounterCount(1,PLAYER_COUNTER_HEAT)
		local b1=Duel.IsCanAddPlayerCounter(tp,PLAYER_COUNTER_HEAT,val,e,tp,REASON_EFFECT)
		local b2=Duel.IsCanAddPlayerCounter(1-tp,PLAYER_COUNTER_HEAT,val,e,tp,REASON_EFFECT)
		if not b1 and not b2 then return end
		local opt=aux.Option(tp,id,3,b1,b2)
		local p = opt==0 and tp or 1-tp
		Duel.AddPlayerCounter(p,PLAYER_COUNTER_HEAT,val,e,tp,REASON_EFFECT)
	end
end

--E4
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.PlayerHasFlagEffect(tp,id) then
		Duel.RegisterFlagEffect(tp,id,0,0,1)
		--Other monsters you control gain 100 ATK for each Heat Counter on yourself, also monsters your opponent controls lose 100 ATK for each Heat Counter on them.
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(function(_e,_c) return not _c:IsOriginalCodeRule(id) end)
		e1:SetValue(s.atkval2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetValue(s.atkval3)
		Duel.RegisterEffect(e2,tp)
		--During your opponent's Standby Phase: They can take damage in multiples of 100, and if they do, they can remove 1 Heat Counter from a player (of their choice) for each 100 damage they took this way.
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(id,5))
		e3:SetCategory(CATEGORY_DAMAGE)
		e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_PHASE|PHASE_STANDBY)
		e3:OPT()
		e3:SetFunctions(
			s.rmcon,
			nil,
			s.rmtg,
			s.rmop
		)
		Duel.RegisterEffect(e3,1-tp)
	end
end
function s.atkval2(e,c)
	return Duel.GetPlayerCounterCount(e:GetOwnerPlayer(),PLAYER_COUNTER_HEAT)*100
end
function s.atkval3(e,c)
	return Duel.GetPlayerCounterCount(1-e:GetOwnerPlayer(),PLAYER_COUNTER_HEAT)*-100
end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,100)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.AnnounceNumberMinMax(tp,100,math.ceil(Duel.GetLP(tp)/100)*100,nil,100)
	local dam=math.floor(Duel.Damage(tp,n,REASON_EFFECT)/100)
	if dam>0 then
		for p=tp,1-tp,1-2*tp do
			if dam>0 and Duel.IsCanRemovePlayerCounter(tp,PLAYER_COUNTER_HEAT,1,e,tp,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(id,p==tp and 6 or 7)) then
				local rct=Duel.AnnounceNumberMinMax(tp,1,math.min(dam,Duel.GetPlayerCounterCount(p,PLAYER_COUNTER_HEAT)))
				dam=dam-rct
				Duel.RemovePlayerCounter(p,PLAYER_COUNTER_HEAT,rct,e,tp,REASON_EFFECT)
			end
		end
	end	
end