--[[
「■」篝
Kagari, Avatar of the Daisy Theory
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	aux.LocationAfterCostEffects[EFFECT_CANNOT_REMOVE]=true
	c:EnableReviveLimit()
	--2+ Level 5 monsters
	aux.AddXyzProcedure(c,nil,5,2,nil,nil,99)
	--Let the fate decide...
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_MOVE)
	e1:SetFunctions(
		s.condition,
		nil,
		nil,
		s.operation
	)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.PlayerHasFlagEffect(ep,id+300) then
		Duel.RegisterFlagEffect(ep,id+300,RESET_PHASE|PHASE_END,0,1,0)
	end
	Duel.UpdateFlagEffectLabel(ep,id+300,ev)
end

s.EffectCategories={
	{CATEGORY_DAMAGE,CATEGORY_DAMAGE,CATEGORY_RECOVER,CATEGORY_DAMAGE,0,0},
	nil,
	nil,
	nil,
	{CATEGORY_TOHAND,0,0,CATEGORY_TOHAND,CATEGORY_HANDES,CATEGORY_HANDES},
	{0,CATEGORY_ATKCHANGE,CATEGORY_DAMAGE,CATEGORY_SPECIAL_SUMMON|CATEGORY_GRAVE_SPSUMMON,0,CATEGORY_TOHAND},
	{0,CATEGORY_SPECIAL_SUMMON,CATEGORY_SPECIAL_SUMMON,0,0,0},
	{CATEGORY_ATKCHANGE,0,0,CATEGORY_ATKCHANGE,0,CATEGORY_TOGRAVE|CATEGORY_DAMAGE},
	{CATEGORY_DAMAGE,CATEGORY_RECOVER,CATEGORY_SPECIAL_SUMMON|CATEGORY_GRAVE_SPSUMMON,CATEGORY_SPECIAL_SUMMON|CATEGORY_GRAVE_SPSUMMON,CATEGORY_DAMAGE|CATEGORY_HANDES,CATEGORY_TODECK},
	{CATEGORY_SPECIAL_SUMMON|CATEGORY_GRAVE_SPSUMMON,CATEGORY_SPECIAL_SUMMON|CATEGORY_DECKDES,CATEGORY_SPECIAL_SUMMON|CATEGORY_GRAVE_SPSUMMON,CATEGORY_SPECIAL_SUMMON,CATEGORY_SPECIAL_SUMMON|CATEGORY_GRAVE_SPSUMMON|CATEGORY_DECKDES,0}
}

s.EffectCodes={
	{EVENT_SPSUMMON_SUCCESS,EVENT_TO_GRAVE,EVENT_CHAINING,EVENT_DESTROYED,EFFECT_UPDATE_ATTACK,EFFECT_UPDATE_ATTACK},
	{PHASE_STANDBY,0,PHASE_END,0,0,PHASE_END},
	{}
}

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and not c:IsPreviousLocation(LOCATION_MZONE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res={}
	for i=1,10 do
		table.insert(res,Duel.GetRandomNumber(6))
	end
	
	local e1=Effect.CreateEffect(c)
	local e2=Effect.CreateEffect(c)
	local e3=Effect.CreateEffect(c)
	
	--[[Dice 1:
		1: You can use this card's (2) and (3) effects during either player's turn, but only once per turn.
		2: You can use this card's (2) and (3) effects during either player's turn, but only up to twice per turn.
		3: You can only use this card's (2) and (3) effects once per turn.
		4: You can only use this card's (2) and (3) effects up to twice per turn.
		5: You can use this card's (2) and (3) effects during either player's turn, but only once per turn.
		6: You can use this card's (2) and (3) effects during either player's turn, but only up to twice per turn.
	]]
	--local d1=res[2]
	local d1=1
	local desc1=aux.Stringid(id+1,d1>=5 and d1-4 or d1)
	c:RegisterFlagEffect(id,RESET_EVENT|RESET_TOFIELD|RESET_MSCHANGE,EFFECT_FLAG_CLIENT_HINT,0,1,desc1)
	local ctlim = d1%2==0 and 2 or 1
	local isFastEffect = d1<3 or d1>4
	e2:SetCountLimit(ctlim,id)
	e3:SetCountLimit(ctlim,id)
	
	--[[Dice 2 - Determines effect (1):
		1:(1): If this card is Special Summoned: You take damage until your LP becomes 1000.
		2:(1): If this card is sent to the GY: Your opponent takes 1000 damage.
		3:(1): If this card's (2) and (3) effects are activated: You gain 1000 LP.
		4:(1): If this card is destroyed by your opponent: They take 1000 damage for each card they control.
		5:(1): Monsters you control gain 1000 ATK/DEF.
		6:(1): Monsters your opponent control lose 1000 ATK/DEF.]]
	local d2=res[2]
	local desc2=aux.Stringid(id+2,d2)
	c:RegisterFlagEffect(id,RESET_EVENT|RESET_TOFIELD|RESET_MSCHANGE,EFFECT_FLAG_CLIENT_HINT,0,2,desc2)
	
	local cat=s.EffectCategories[1][d2]
	if cat~=0 then
		e1:SetCategory(cat)
	end
	if d2<=4 then
		e1:SetDescription(desc2)
		e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(s.EffectCodes[1][d2])
		e1:SetCondition(s.d2condition(d2))
		e1:SetTarget(s.d2target(d2))
		e1:SetOperation(s.d2operation(d2))
	else
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(s.EffectCodes[1][d2])
		e1:SetRange(LOCATION_MZONE)
		if d2==5 then
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetValue(1000)
		else
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetValue(-1000)
		end
	end
	e1:SetReset(RESET_EVENT|RESET_TOFIELD|RESET_MSCHANGE)
	c:RegisterEffect(e1)
	if d2>4 then
		e1:UpdateDefenseClone(c)
	end
	
	--[[Dice 3:
	1:(2): During the Standby Phase: You can attach 1 monster from your Deck to this card as material.
	2:(2): During the Main Phase: You can randomly attach 2 monsters from your Deck to this card as material.
	3:(2): During the End Phase: You can randomly attach 1 monster from your opponent's Deck to this card as material.
	4:(2): During the Main Phase: You can look at your opponent's hand, and if you do, attach 1 card from their hand to this card as material.
	5:(2): During the Battle Phase: You can look at your opponent's Extra Deck, and if you do, attach 1 card from their Extra Deck to this card as material.
	6:(2): During the End Phase: Excavate the top 10 cards of your Deck and attach all excavated monsters to this card as material, also shuffle the rest into the Deck]]
	local d3=res[3]
	local desc3=aux.Stringid(id+3,d3)
	c:RegisterFlagEffect(id,RESET_EVENT|RESET_TOFIELD|RESET_MSCHANGE,EFFECT_FLAG_CLIENT_HINT,0,3,desc3)
	
	e2:SetDescription(desc3)
	if d3==2 or d3==4 then
		if not isFastEffect then
			e2:SetType(EFFECT_TYPE_IGNITION)
		else
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetCode(EVENT_FREE_CHAIN)
			e2:SetHintTiming(TIMING_MAIN_END)
		end
	elseif d3==5 then
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
	else
		e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_PHASE|s.EffectCodes[2][d3])
	end
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.d3condition(d3,isFastEffect))
	e2:SetTarget(s.d3target(d3))
	e2:SetOperation(s.d3operation(d3))
	e2:SetReset(RESET_EVENT|RESET_TOFIELD|RESET_MSCHANGE)
	c:RegisterEffect(e2)
	
	--[[Dice 4:
	1:(3): During the Main Phase: You can detach 1 material from this card; apply the following effects (simultaneously), based on the detached material's properties:
	2:(3): If an attack is declared involving this card: Detach 2 materials from this card; apply the following effects (simultaneously), based on the detached material's properties (skip over any that do not apply):
	3:(3): During the Standby Phase: Detach 1 material from this card; apply the following effects (simultaneously), based on the detached material's properties (skip over any that do not apply):
	4:(3): During the End Phase: Apply the following effects (simultaneously), based on this card's materials' properties (Skip over any that do not apply. You can only apply each effect once per turn this way.):
	5:(3): During the Main Phase: You can detach all materials from this card, and if you do, it becomes the End Phase, then banish 1 card from your GY that was detached by this card's effect, and if you do, apply the following effects (simultaneously), based on the banished card's properties (skip over any that do not apply):
	6:(3): If this card would leave the field, you can detach 1 material from this card instead, and if you do, apply the following effects, based on the detached material's properties (skip over any that do not apply):
	]]
	local d4,d5,d6,d7,d8,d9,d10=res[4],res[5],res[6],res[7],res[8],res[9],res[10]
	local desc4=aux.Stringid(id+4,d4)
	for i=4,10 do
		c:RegisterFlagEffect(id,RESET_EVENT|RESET_TOFIELD|RESET_MSCHANGE,EFFECT_FLAG_CLIENT_HINT,0,i,aux.Stringid(id+i,res[i]))
	end
	
	e3:SetDescription(desc4)
	if d4==1 or d4==5 then
		if not isFastEffect then
			e3:SetType(EFFECT_TYPE_IGNITION)
		else
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_FREE_CHAIN)
			e3:SetHintTiming(TIMING_MAIN_END)
		end
		e3:SetRange(LOCATION_MZONE)
		if d4==1 then
			e3:SetCost(aux.DummyCost)
		else
			e3:SetCategory(CATEGORY_REMOVE)
		end
	elseif d4==2 then
		e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_ATTACK_ANNOUNCE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCost(aux.DummyCost)
	elseif d4==6 then
		e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetCode(EFFECT_SEND_REPLACE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTarget(s.d4target_6(d4,d5,d6,d7,d8,d9,d10))
		e3:SetValue(s.d4value)
		e3:SetOperation(s.d4operation_6(d4,d5,d6,d7,d8,d9,d10))
	else
		e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_PHASE|(d4==3 and PHASE_STANDBY or PHASE_END))
		e3:SetRange(LOCATION_MZONE)
		if d4==3 then
			e3:SetCost(aux.DummyCost)
		end
	end
	if d4~=6 then
		e3:SetCondition(s.d4condition(d4,isFastEffect))
		e3:SetTarget(s.d4target(d4,d5,d6,d7,d8,d9,d10))
		e3:SetOperation(s.d4operation(d4,d5,d6,d7,d8,d9,d10))
	end
	e3:SetReset(RESET_EVENT|RESET_TOFIELD|RESET_MSCHANGE)
	c:RegisterEffect(e3)
	if d4==6 then
		local e3x=e3:Clone()
		e3x:SetCode(EFFECT_DESTROY_REPLACE)
		c:RegisterEffect(e3x)
	end
	
	--[[Dice 5:
	1:● LIGHT: Your opponent reveals their hand and you can exchange 1 card in your hand with 1 card in their hand (your choice)
	2:● LIGHT: Until the end of this turn, you must play with your hand revealed
	3:● LIGHT: Until the end of this turn, your opponent must play with your hand revealed
	4:● LIGHT: Reveal 1 card in your hand, and if you do, add, from your Deck to your hand, 1 card with the same type as the revealed card (Monster, Spell, Trap).
	5:● LIGHT: Discard 1 card.
	6:● LIGHT: Your opponent discards 1 card.
	]]
	
	--[[Dice 6:
	1:● DARK: Skip the Battle Phase of this turn.
	2:● DARK: Target 1 monster on the field; its ATK becomes 0.
	3:● 1000 or less DEF: Inflict damage to your opponent equal to that DEF.
	4:● Level 5: During the End Phase of this turn, you can Special Summon 1 monster from your GY.
	5:● DARK: For the rest of this turn, players cannot declare an attack unless they previously took 1000 damage during this turn (for each attack they want to declare).
	6:● 2000 or more ATK: Target 1 card your opponent controls; return that target to the hand.]]
	
	--[[Dice 7:
	1:● WIND: Set 1 Spell/Trap card from your GY in your Spell & Trap Zone.
	2:● WIND: Special Summon 1 monster from your GY, in face-down Defense Position.
	3:● WIND: Look at your opponent's Deck, and if you do, Special Summon 1 monster from their Deck to their field, but banish it when it leaves the field.
	4:● WIND: Look at your opponent's Deck, and if you do, Set 1 Spell/Trap from their Deck to your Spell & Trap zone, but banish it when it leaves the field.
	5:● WIND: Place 1 monster from your hand face-up in your Monster Zone.
	6:● WIND: Place 1 Continous Spell/Trap from your hand face-up in your Spell & Trap Zone]]
	
	--[[Dice 8:
	1:● WATER: Until your opponent's next Standby Phase, all monsters they control will lose 1000 ATK.
	2:● 1000 or less ATK: Attach up to 2 monsters with 1000 or more ATK from your Deck to this card as material.
	3:● 1000 or more ATK: Attach up to 2 monsters with 1000 or less ATK from either field and/or GY to this card as material.
	4:● WATER: Detach all other materials from this card, and if you do, all monsters you currently control gain 1000 ATK for each material detached this way.
	5:● WATER: Monsters with 1000 or more ATK cannot declare attacks until your opponent's next Standby Phase.
	6:● WATER: Send any number of cards your opponent controls to the GY, and if you do, you take 1000 damage for each card sent to the GY by this effect.]]
	
	--[[Dice 9:
	1:● FIRE: Target 1 face-up monster on the field; inflict damage equal to its ATK to both players.
	2:● FIRE: Target 1 face-up monster on the field; both players gain LP equal to its DEF.
	3:● 1000 or more ATK: Special Summon 1 monster from your GY, with an higher ATK than the detached material's ATK.
	4:● 1000 or less DEF: Special Summon 1 monster from your opponent's GY, with ATK less or equal than the difference between both players' LP.
	5:● FIRE: Target 1 face-up monster on the field; inflict damage to your opponent equal to its combined ATK and DEF. Your opponent can discard cards from their hand to decrease the damage by 1000 for each card.
	6:● FIRE: Shuffle a number of cards from the top of your Deck into your opponent's Deck, equal to the difference between the number of cards between both players' Decks.]]

	--[[Dice 10:
	1:● EARTH: Special Summon 1 EARTH monster from your GY.
	2:● EARTH: Special Summon 1 EARTH monster from your Deck.
	3:● EARTH: Special Summon, from either GY, 1 monster that was sent to the GY this turn.
	4:● EARTH: Special Summon 1 banished monster.
	5:● EARTH: Special Summon, from your Deck or GY, 1 monster that has the same name as a monster you control.
	6:● EARTH: This card gains this effect: "If this card is sent to the GY: You can Special Summon it."]]
end

function s.d4condition(d4,isFastEffect)
	if d4==1 or d4==5 then
		return 	function(e,tp,eg,ep,ev,re,r,rp)
					return Duel.IsMainPhase() and (isFastEffect or Duel.IsTurnPlayer(tp))
				end
	elseif d4==2 then
		return 	function(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetHandler()
					return Duel.GetAttacker()==c or Duel.GetAttackTarget()==c
				end
	elseif d4==5 then
		return 	function(e,tp,eg,ep,ev,re,r,rp)
					return Duel.IsBattlePhase() and (isFastEffect or (Duel.IsTurnPlayer(tp) and Duel.GetCurrentChain()==0))
				end
	else
		return aux.TRUE
	end
end
function s.activationLegalityFilter(c,d4,d5,d6,d7,d8,d9,d10,e,tp,detachcost)
	if d4==5 then
		c:SetLocationAfterCost(LOCATION_GRAVE)
		local res=c:IsAbleToRemove()
		c:SetLocationAfterCost(0)
		if not res then return false end
	end
	detachcost = detachcost and detachcost or 0
	return s.activationLegalityd5(c,d4,d5,e,tp)
		or s.activationLegalityd6(c,d4,d6,e,tp)
		or s.activationLegalityd7(c,d4,d7,e,tp)
		or s.activationLegalityd8(c,d4,d8,e,tp,detachcost)
		or s.activationLegalityd9(c,d4,d9,e,tp)
		or s.activationLegalityd10(c,d4,d10,e,tp)
end
function s.ensureResolutionCheck(d4,d5,d6,d7,d8,d9,d10)
	return	function(g,e,tp,mg,c)
				if #g==1 then return true end
				local res=s.activationLegalityFilter(c,d4,d5,d6,d7,d8,d9,d10,e,tp)
				return res, not res
			end
end
function s.d4target(d4,d5,d6,d7,d8,d9,d10)
	if d4==1 or d4==3 then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					local g=c:GetOverlayGroup()
					if chk==0 then
						if not e:IsCostChecked() then return false end
						return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and (d4==1 or g:IsExists(s.activationLegalityFilter,1,nil,d4,d5,d6,d7,d8,d9,d10,e,tp,1))
					end
					Duel.HintMessage(tp,HINTMSG_REMOVEXYZ)
					local tc=g:IsExists(s.activationLegalityFilter,1,nil,d4,d5,d6,d7,d8,d9,d10,e,tp,1) and g:FilterSelect(tp,s.activationLegalityFilter,1,1,nil,d4,d5,d6,d7,d8,d9,d10,e,tp):GetFirst() or g:Select(tp,1,1,nil):GetFirst()
					local attr,lv,atk,def,typ=tc:GetAttribute(),tc:GetLevel(),tc:GetAttack(),tc:GetDefense(),tc:GetType()
					e:SetLabel(attr,lv,atk,def,typ)
					Duel.SendtoGrave(tc,REASON_COST)
					Duel.RaiseSingleEvent(tc,EVENT_DETACH_MATERIAL,e,REASON_COST,tp,0,0)
					Duel.RaiseEvent(Group.FromCards(tc),EVENT_DETACH_MATERIAL,e,REASON_COST,tp,0,0)
					e:SetCategory(0)
					e:SetProperty(0)
					s.d5info(d5,e,tp,attr)
					s.d6info(d6,e,tp,attr,lv,atk,def,typ)
					s.d7info(d7,e,tp,attr)
					s.d8info(d8,e,tp,attr,lv,atk,def,typ)
					s.d9info(d9,e,tp,attr,lv,atk,def,typ)
					s.d10info(d10,e,tp,attr)
				end
	elseif d4==2 then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					local g=c:GetOverlayGroup()
					if chk==0 then
						if not e:IsCostChecked() then return false end
						return c:CheckRemoveOverlayCard(tp,2,REASON_COST)
					end
					Duel.HintMessage(tp,HINTMSG_REMOVEXYZ)
					local sg=g:IsExists(s.activationLegalityFilter,1,nil,d4,d5,d6,d7,d8,d9,d10,e,tp,2) and aux.SelectUnselectGroup(g,e,tp,2,2,s.ensureResolutionCheck(d4,d5,d6,d7,d8,d9,d10),1,tp,HINTMSG_REMOVEXYZ) or g:Select(tp,2,2,nil)
					local attr,lv,atk,def,typ=0,{},{},{},0
					Duel.SendtoGrave(sg,REASON_COST)
					for tc in aux.Next(sg) do
						attr=attr|tc:GetAttribute()
						table.insert(lv,tc:GetLevel())
						table.insert(atk,tc:GetAttack())
						table.insert(def,tc:GetDefense())
						typ=typ|tc:GetType()
						Duel.RaiseSingleEvent(tc,EVENT_DETACH_MATERIAL,e,REASON_COST,tp,0,0)
					end
					Duel.RaiseEvent(sg,EVENT_DETACH_MATERIAL,e,REASON_COST,tp,0,0)
					e:SetLabel(attr)
					e:SetCategory(0)
					e:SetProperty(0)
					s.d5info(d5,e,tp,attr)
					s.d6info(d6,e,tp,attr,lv,atk,def,typ)
					s.d7info(d7,e,tp,attr)
					s.d8info(d8,e,tp,attr,lv,atk,def,typ)
					s.d9info(d9,e,tp,attr,lv,atk,def,typ)
					s.d10info(d10,e,tp,attr)
				end
	elseif d4==4 then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then
						return true
					end
					e:SetCategory(0)
					e:SetProperty(0)
					s.d5info(d5,e,tp,attr,true)
					s.d6info(d6,e,tp,attr,lv,atk,def,typ,true)
					s.d7info(d7,e,tp,attr,true)
					s.d8info(d8,e,tp,attr,lv,atk,def,typ,true)
					s.d9info(d9,e,tp,attr,lv,atk,def,typ,true)
					s.d10info(d10,e,tp,attr,true)
				end
	elseif d4==5 then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					local g=c:GetOverlayGroup()
					if chk==0 then
						return Duel.IsPlayerCanRemove(tp) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and g:IsExists(Card.IsAbleToRemove,1,nil) --and g:IsExists(s.activationLegalityFilter,1,nil,d4,d5,d6,d7,d8,d9,d10,e,tp)
					end
					e:SetCategory(CATEGORY_REMOVE)
					e:SetProperty(0)
					s.d5info(d5,e,tp,attr,true)
					s.d6info(d6,e,tp,attr,lv,atk,def,typ,true)
					s.d7info(d7,e,tp,attr,true)
					s.d8info(d8,e,tp,attr,lv,atk,def,typ,true)
					s.d9info(d9,e,tp,attr,lv,atk,def,typ,true)
					s.d10info(d10,e,tp,attr,true)
					Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
				end
	end
end
function s.d4operation(d4,d5,d6,d7,d8,d9,d10)
	if d4<=3 then
		return	function(e,tp,eg,ep,ev,re,r,rp)
					local attr,lv,atk,def,typ=e:GetLabel()
					s.d5operation(d4,d5,e,tp,attr)
					s.d6operation(d4,d6,e,tp,attr,lv,atk,def,typ)
					s.d7operation(d4,d7,e,tp,attr)
					s.d8operation(d4,d8,e,tp,attr,lv,atk,def,typ)
					s.d9operation(d4,d9,e,tp,attr,lv,atk,def,typ)
					s.d10operation(d4,d10,e,tp,attr)
				end
	elseif d4==4 then
		return	function(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetHandler()
					local g=c:GetOverlayGroup()
					if not c:IsRelateToChain() or not g or #g==0 then return end
					local attr,lv,atk,def,typ=0,{},{},{},0
					for tc in aux.Next(g) do
						attr=attr|tc:GetAttribute()
						table.insert(lv,tc:GetLevel())
						table.insert(atk,tc:GetAttack())
						table.insert(def,tc:GetDefense())
						typ=typ|tc:GetType()
					end
					s.d5operation(d4,d5,e,tp,attr)
					s.d6operation(d4,d6,e,tp,attr,lv,atk,def,typ)
					s.d7operation(d4,d7,e,tp,attr)
					s.d8operation(d4,d8,e,tp,attr,lv,atk,def,typ)
					s.d9operation(d4,d9,e,tp,attr,lv,atk,def,typ)
					s.d10operation(d4,d10,e,tp,attr)
				end
	elseif d4==5 then
		return	function(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetHandler()
					if c:IsRelateToChain() then
						local ct=0
						for i=c:GetOverlayGroup():GetCount(),1,-1 do
							if c:CheckRemoveOverlayCard(tp,i,REASON_EFFECT) then
								ct=i
								break
							end
						end
						if ct>0 and c:RemoveOverlayCard(tp,ct,ct,REASON_EFFECT)>0 then
							local g=Duel.GetGroupOperatedByThisEffect(e)
							if #g>0 and not Duel.IsEndPhase() then
								local p=Duel.GetTurnPlayer()
								Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
								Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
								Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
								Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE|PHASE_END,1,1)
								Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
								local e1=Effect.CreateEffect(c)
								e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
								e1:SetType(EFFECT_TYPE_FIELD)
								e1:SetCode(EFFECT_CANNOT_BP)
								e1:SetTargetRange(1,0)
								e1:SetReset(RESET_PHASE|PHASE_END)
								Duel.RegisterEffect(e1,p)
								Duel.HintMessage(tp,HINTMSG_REMOVE)
								-- local rg=g:IsExists(s.activationLegalityFilter,1,nil,d4,d5,d6,d7,d8,d9,d10,e,tp) and g:FilterSelect(tp,s.activationLegalityFilter,1,1,nil,d4,d5,d6,d7,d8,d9,d10,e,tp) or g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
								local rg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
								if #rg>0 then
									local tc=rg:GetFirst()
									Duel.HintSelection(rg)
									local attr,lv,atk,def,typ=tc:GetAttribute(),tc:GetLevel(),tc:GetAttack(),tc:GetDefense(),tc:GetType()
									if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
										s.d5operation(d4,d5,e,tp,attr)
										s.d6operation(d4,d6,e,tp,attr,lv,atk,def,typ)
										s.d7operation(d4,d7,e,tp,attr)
										s.d8operation(d4,d8,e,tp,attr,lv,atk,def,typ)
										s.d9operation(d4,d9,e,tp,attr,lv,atk,def,typ)
										s.d10operation(d4,d10,e,tp,attr)
									end
								end
							end
						end
					end
				end
	end
end

function s.d4target_6(d4,d5,d6,d7,d8,d9,d10)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				local g=c:GetOverlayGroup()
				if chk==0 then
					return not c:IsReason(REASON_REPLACE) and (e:GetCode()==EFFECT_DESTROY_REPLACE or (not c:IsReason(REASON_DESTROY) and c:GetDestination()&LOCATION_ONFIELD==0)) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
					--and g:IsExists(s.activationLegalityFilter,1,nil,d4,d5,d6,d7,d8,d9,d10,e,tp)
					
				end
				if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					return true
				end
				return false
			end
end
function s.d4value(e,c)
	return not c:IsReason(REASON_REPLACE) and c:GetDestination()&LOCATION_ONFIELD==0
end
function s.d4operation_6(d4,d5,d6,d7,d8,d9,d10)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local g=c:GetOverlayGroup()
				if not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) or #g==0 then return end
				Duel.HintMessage(tp,HINTMSG_REMOVE)
				local rg=g:Select(tp,1,1,nil)
				if #rg>0 then
					local tc=rg:GetFirst()
					local attr,lv,atk,def,typ=tc:GetAttribute(),tc:GetLevel(),tc:GetAttack(),tc:GetDefense(),tc:GetType()
					if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
						Duel.RaiseSingleEvent(tc,EVENT_DETACH_MATERIAL,e,REASON_EFFECT,tp,0,0)
						Duel.RaiseEvent(Group.FromCards(tc),EVENT_DETACH_MATERIAL,e,REASON_EFFECT,tp,0,0)
						s.d5operation(d4,d5,e,tp,attr)
						s.d6operation(d4,d6,e,tp,attr,lv,atk,def,typ)
						s.d7operation(d4,d7,e,tp,attr)
						s.d8operation(d4,d8,e,tp,attr,lv,atk,def,typ)
						s.d9operation(d4,d9,e,tp,attr,lv,atk,def,typ)
						s.d10operation(d4,d10,e,tp,attr)
					end
				end
			end
end

--D10
function s.d10info(d10,e,tp,attr,possible)
	if not possible then
		if attr&ATTRIBUTE_EARTH==0 then return end
	end
	
	local cat=s.EffectCategories[10][d10]
	if cat~=0 then
		e:SetCategory(e:GetCategory()|cat)
	end
	info=possible and Duel.SetPossibleOperationInfo or Duel.SetOperationInfo
	if d10==1 or d10==3 then
		info(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif d10==2 then
		info(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif d10==4 then
		info(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	elseif d10==5 then
		info(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
	elseif e7==3 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
	end
end
function s.activationLegalityd10(c,d4,d10,e,tp)
	if not c:IsAttribute(ATTRIBUTE_EARTH) then return end
	if d10==1 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(10<<16)|1))
			and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.d10filter_1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	elseif d10==2 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(10<<16)|2))
			and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.d10filter_1,tp,LOCATION_DECK,0,1,nil,e,tp)
	elseif d10==3 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(10<<16)|3))
			and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.d10filter_3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp)
	elseif d10==4 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(10<<16)|4))
			and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.d10filter_4,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp)
	elseif d10==5 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(10<<16)|5))
			and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.d10filter_5,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,e,tp)
	elseif d10==6 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(10<<16)|6))
	end
	return false
end
function s.d10filter_1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.d10filter_3(c,e,tp)
	return c:GetTurnID()==Duel.GetTurnCount() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.d10filter_4(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.d10filter_5(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExists(false,s.d10filter_5_2,tp,LOCATION_MZONE,0,1,nil,{c:GetCode()})
end
function s.d10filter_5_2(c,codes)
	return c:IsFaceup() and c:IsCode(table.unpack(codes))
end
function s.d10operation(d4,d10,e,tp,attr)
	if attr&ATTRIBUTE_EARTH==0 or (d4==4 and Duel.PlayerHasFlagEffectLabel(tp,id+100,(10<<16)|d10)) then return end
	
	if d10%2>0 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		local f=d10==1 and s.d10filter_1 or d10==3 and s.d10filter_3 or s.d10filter_5
		local loc1=d10==5 and LOCATION_DECK or 0
		local loc2=d10==1 and 0 or LOCATION_GRAVE
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(f),tp,LOCATION_GRAVE|loc1,loc2,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	
	elseif d10==2 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.d10filter_1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	
	elseif d10==4 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.d10filter_4,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	
	elseif d10==6 then
		local c=e:GetHandler()
		if (d4==6 or c:IsRelateToChain()) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:Desc(7,id)
			e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
			e2:SetProperty(EFFECT_FLAG_DELAY)
			e2:SetCode(EVENT_TO_GRAVE)
			e2:SetTarget(s.d10sptg)
			e2:SetOperation(s.d10spop)
			e2:SetReset(RESET_EVENT|RESET_TOFIELD|RESET_MSCHANGE)
			c:RegisterEffect(e2)
		end
	end
	
	if d4==4 then
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE|PHASE_END,0,1,(10<<16)|d10)
	end
end
function s.d10sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.d10spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--D9
function s.d9info(d9,e,tp,attr,lv,atk,def,typ,possible)
	local cat=s.EffectCategories[9][d9]
	if cat~=0 then
		e:SetCategory(e:GetCategory()|cat)
	end
	info=possible and Duel.SetPossibleOperationInfo or Duel.SetOperationInfo
	if d9==1 then
		if not possible and attr&ATTRIBUTE_FIRE==0 then return end
		e:SetProperty(e:GetProperty()|EFFECT_FLAG_CARD_TARGET)
		if not possible then
			local tc=Duel.Select(HINTMSG_TARGET,true,tp,s.d9filter_1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
			tc:RegisterFlagEffect(id+500,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1,e:GetFieldID())
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,tc:GetAttack())
		end
	
	elseif d9==2 then
		if not possible and attr&ATTRIBUTE_FIRE==0 then return end
		e:SetProperty(e:GetProperty()|EFFECT_FLAG_CARD_TARGET)
		if not possible then
			local tc=Duel.Select(HINTMSG_TARGET,true,tp,s.d9filter_2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
			tc:RegisterFlagEffect(id+600,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1,e:GetFieldID())
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,tc:GetDefense())
		end
		
	elseif d9==3 then
		local v=atk
		if type(v)=="table" then
			for i,val in ipairs(v) do
				if i==1 or val>v then
					v=val
				end
			end
		end
		if not possible and v<1000 then return end
		info(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	
	elseif d9==4 then
		local v=atk
		if type(v)=="table" then
			for i,val in ipairs(v) do
				if i==1 or val<v then
					v=val
				end
			end
		end
		if not possible and v>1000 then return end
		info(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_GRAVE)
	
	elseif d9==5 then
		if not possible and attr&ATTRIBUTE_FIRE==0 then return end
		e:SetProperty(e:GetProperty()|EFFECT_FLAG_CARD_TARGET)
		if not possible then
			local tc=Duel.Select(HINTMSG_TARGET,true,tp,s.d9filter_5,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
			tc:RegisterFlagEffect(id+700,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1,e:GetFieldID())
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetAttack()+tc:GetDefense())
			Duel.SetPossibleOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
		end

	elseif d9==6 then
		if not possible and attr&ATTRIBUTE_FIRE==0 then return end
		info(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK)
	end
end
function s.activationLegalityd9(c,d4,d9,e,tp,detachcost)
	if d9==1 then
		return c:IsAttribute(ATTRIBUTE_FIRE) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(9<<16)|1))
			and Duel.IsExists(true,s.d9filter_1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	elseif d9==2 then
		return c:IsAttribute(ATTRIBUTE_FIRE) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(9<<16)|2))
			and Duel.IsExists(true,s.d9filter_2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,nil)
	elseif d9==3 then
		return c:IsMonster() and c:IsAttackAbove(1000) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(9<<16)|3))
			and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.d9filter_3,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetAttack()+1)
	elseif d9==4 then
		return c:IsMonster() and c:IsAttackBelow(1000) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(9<<16)|4))
			and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.d9filter_4,tp,0,LOCATION_GRAVE,1,nil,e,tp,math.abs(Duel.GetLP(0)-Duel.GetLP(1)))
	elseif d9==5 then
		return c:IsAttribute(ATTRIBUTE_FIRE) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(9<<16)|5))
			and Duel.IsExists(true,s.d9filter_5,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	elseif d9==6 then
		if not (c:IsAttribute(ATTRIBUTE_FIRE) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(9<<16)|6))) then return false end
		local ct=math.abs(Duel.GetDeckCount(0)-Duel.GetDeckCount(1))
		if ct==0 then return end
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:IsExists(Card.IsAbleToDeck,1,nil)
	end
	return false
end
function s.d9filter_1(c)
	return c:IsFaceup() and c:IsAttackAbove(1)
end
function s.d9filter_2(c)
	return c:IsFaceup() and c:IsDefenseAbove(1)
end
function s.d9filter_3(c,e,tp,atk)
	return c:IsAttackAbove(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.d9filter_4(c,e,tp,val)
	return c:IsAttackBelow(val) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.d9filter_5(c)
	return c:IsFaceup() and (c:IsAttackAbove(1) or c:IsDefenseAbove(1))
end
function s.d9operation(d4,d9,e,tp,attr,lv,atk,def,typ)
	if d4==4 and Duel.PlayerHasFlagEffectLabel(tp,id+100,(9<<16)|d9) then return end
	if d9==1 then
		if attr&ATTRIBUTE_FIRE==0 then return end
		if d4==6 then return end
		local tc
		if d4>3 then
			tc=Duel.Select(HINTMSG_TARGET,true,tp,s.d9filter_1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		else
			tc=Duel.GetTargetCards():Filter(Card.HasFlagEffectLabel,nil,id+500,e:GetFieldID()):GetFirst()
		end
		if tc and tc:IsFaceup() then
			local v=tc:GetAttack()
			for p in aux.TurnPlayers() do
				Duel.Damage(p,v,REASON_EFFECT,true)
			end
			Duel.RDComplete()
		end
		
	elseif d9==2 then
		if attr&ATTRIBUTE_FIRE==0 then return end
		if d4==6 then return end
		local tc
		if d4>3 then
			tc=Duel.Select(HINTMSG_TARGET,true,tp,s.d9filter_2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		else
			tc=Duel.GetTargetCards():Filter(Card.HasFlagEffectLabel,nil,id+600,e:GetFieldID()):GetFirst()
		end
		if tc and tc:IsFaceup() then
			local v=tc:GetDefense()
			for p in aux.TurnPlayers() do
				Duel.Recover(p,v,REASON_EFFECT,true)
			end
			Duel.RDComplete()
		end
	
	elseif d9==3 then
		if typ&TYPE_MONSTER==0 then return end
		local v0=atk
		if type(atk)=="table" then
			for i,val in ipairs(atk) do
				if i==1 or val>v0 then
					v0=val
				end
			end
		end
		if v0<1000 then return end
		if Duel.GetMZoneCount(tp)>0 then
			local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,aux.NecroValleyFilter(s.d9filter_3),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,atk+1)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	
	elseif d9==4 then
		if typ&TYPE_MONSTER==0 then return end
		local v0=atk
		if type(atk)=="table" then
			for i,val in ipairs(atk) do
				if i==1 or val<v0 then
					v0=val
				end
			end
		end
		if v0>1000 then return end
		if Duel.GetMZoneCount(tp)>0 then
			local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,aux.NecroValleyFilter(s.d9filter_4),tp,0,LOCATION_GRAVE,1,1,nil,e,tp,math.abs(Duel.GetLP(0)-Duel.GetLP(1)))
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	
	elseif d9==5 then
		if attr&ATTRIBUTE_FIRE==0 then return end
		if d4==6 then return end
		local tc
		if d4>3 then
			tc=Duel.Select(HINTMSG_TARGET,true,tp,s.d9filter_5,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		else
			tc=Duel.GetTargetCards():Filter(Card.HasFlagEffectLabel,nil,id+700,e:GetFieldID()):GetFirst()
		end
		if tc and tc:IsFaceup() then
			local v=tc:GetAttack()+tc:GetDefense()
			if v<=0 then return end
			local g=Duel.GetHand(1-tp):Filter(Card.IsDiscardable,nil,REASON_EFFECT|REASON_DISCARD)
			if #g>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,6)) then
				local ct=Duel.DiscardHand(1-tp,nil,1,math.ceil(v/1000),REASON_EFFECT|REASON_DISCARD)
				v=math.max(0,v-ct*1000)
			end
			Duel.Damage(p,v,REASON_EFFECT)
		end
	
	elseif d9==6 then
		if attr&ATTRIBUTE_FIRE==0 then return end
		local ct=math.abs(Duel.GetDeckCount(0)-Duel.GetDeckCount(1))
		if ct==0 then return end
		local g=Duel.GetDecktopGroup(tp,ct):Filter(Card.IsAbleToDeck,nil)
		if #g>0 then
			Duel.DisableShuffleCheck(true)
			if Duel.SendtoDeck(g,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and g:IsExists(aux.PLChk,1,nil,1-tp,LOCATION_DECK) then
				Duel.ShuffleDeck(1-tp)
			end
		end
	end
	
	if d4==4 then
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE|PHASE_END,0,1,(9<<16)|d9)
	end
end

--D8
function s.d8info(d8,e,tp,attr,lv,atk,def,typ,possible)
	local cat=s.EffectCategories[8][d8]
	if cat~=0 then
		e:SetCategory(e:GetCategory()|cat)
	end
	info=possible and Duel.SetPossibleOperationInfo or Duel.SetOperationInfo
	if d8==3 then
		local v=atk
		if type(v)=="table" then
			for i,val in ipairs(v) do
				if i==1 or val>v then
					v=val
				end
			end
		end
		if not possible and v<1000 then return end
		Duel.SetPossibleOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,PLAYER_ALL,0)

	elseif d8==6 then
		if not possible and attr&ATTRIBUTE_WATER==0 then return end
		local g=Duel.Group(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
		info(0,CATEGORY_TOGRAVE,g,1,1-tp,LOCATION_ONFIELD)
		info(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	end
end
function s.activationLegalityd8(c,d4,d8,e,tp,detachcost)
	if d8==1 then
		return c:IsAttribute(ATTRIBUTE_WATER) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(8<<16)|1))
	elseif d8==2 then
		return c:IsMonster() and c:IsAttackBelow(1000) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(8<<16)|2))
			and Duel.IsExists(false,s.d8filter_2,tp,LOCATION_DECK,0,1,nil,e:GetHandler(),e,tp)
	elseif d8==3 then
		return c:IsMonster() and c:IsAttackAbove(1000) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(8<<16)|3))
			and Duel.IsExists(false,s.d8filter_3,tp,LOCATION_MZONE|LOCATION_GRAVE,LOCATION_MZONE|LOCATION_GRAVE,1,nil,e:GetHandler(),e,tp)
	elseif d8==4 then
		local h=e:GetHandler()
		if not (c:IsAttribute(ATTRIBUTE_WATER) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(8<<16)|4))
			and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsExists(false,Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)) then return false end
		if detachcost>0 then
			return h:GetOverlayCount()-detachcost>0
		else
			return h:GetOverlayCount()>1
		end
	elseif d8==5 then
		return c:IsAttribute(ATTRIBUTE_WATER) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(8<<16)|5))
	elseif d8==6 then
		return c:IsAttribute(ATTRIBUTE_WATER) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(8<<16)|6))
			and Duel.IsExists(false,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	end
	return false
end
function s.d8filter_2(c,xyzc,e,tp)
	return c:IsAttackAbove(1000) and c:IsCanBeAttachedTo(xyzc,e,tp,REASON_EFFECT)
end
function s.d8filter_3(c,xyzc,e,tp)
	return c:IsFaceupEx() and (c:IsLocation(LOCATION_MZONE) or c:IsMonster()) and c:IsAttackBelow(1000) and c:IsCanBeAttachedTo(xyzc,e,tp,REASON_EFFECT)
end
function s.d8operation(d4,d8,e,tp,attr,lv,atk,def,typ)
	if d4==4 and Duel.PlayerHasFlagEffectLabel(tp,id+100,(8<<16)|d8) then return end
	if d8==1 then
		if attr&ATTRIBUTE_WATER==0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(-1000)
		e1:SetReset(RESET_PHASE|PHASE_STANDBY|RESET_OPPO_TURN,Duel.GetNextPhaseCount(PHASE_STANDBY,1-tp))
		Duel.RegisterEffect(e1,tp)
		
	elseif d8==2 then
		if typ&TYPE_MONSTER==0 then return end
		local v0=atk
		if type(atk)=="table" then
			for i,val in ipairs(atk) do
				if i==1 or val<v0 then
					v0=val
				end
			end
		end
		if v0>1000 then return end
		local c=e:GetHandler()
		if (d4==6 or c:IsRelateToChain()) then
			local g=Duel.Select(HINTMSG_XMATERIAL,false,tp,s.d8filter_2,tp,LOCATION_DECK,0,1,2,nil,c,e,tp)
			if #g>0 then
				Duel.Attach(g,c,false,e,tp,REASON_EFFECT)
			end
		end
	
	elseif d8==3 then
		if typ&TYPE_MONSTER==0 then return end
		local v0=atk
		if type(atk)=="table" then
			for i,val in ipairs(atk) do
				if i==1 or val>v0 then
					v0=val
				end
			end
		end
		if v0<1000 then return end
		local c=e:GetHandler()
		if (d4==6 or c:IsRelateToChain()) then
			local g=Duel.Select(HINTMSG_XMATERIAL,false,tp,aux.NecroValleyFilter(s.d8filter_3),tp,LOCATION_MZONE|LOCATION_GRAVE,LOCATION_MZONE|LOCATION_GRAVE,1,2,nil,c,e,tp)
			if #g>0 then
				Duel.Attach(g,c,false,e,tp,REASON_EFFECT)
			end
		end
	
	elseif d8==4 then
		if attr&ATTRIBUTE_WATER==0 then return end
		local c=e:GetHandler()
		if (d4==6 or c:IsRelateToChain()) then
			local g=c:GetOverlayGroup()
			if #g==0 then return end
			if d4==4 then
				Duel.HintMessage(tp,aux.Stringid(id,5))
				local exc=g:FilterSelect(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_WATER):GetFirst()
				if exc then
					g:RemoveCard(exc)
				end
			end
			local ct=Duel.SendtoGrave(g,REASON_EFFECT)
			if ct>0 then
				local og=Duel.GetGroupOperatedByThisEffect(e)
				for tc in aux.Next(og) do
					Duel.RaiseSingleEvent(tc,EVENT_DETACH_MATERIAL,e,REASON_EFFECT,tp,0,0)
				end
				Duel.RaiseEvent(og,EVENT_DETACH_MATERIAL,e,REASON_EFFECT,tp,0,0)
				local val=#og*1000
				local ag=Duel.Group(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				for ac in aux.Next(ag) do
					ac:UpdateATK(val,true,{c,true})
				end
			end
		end
	
	elseif d8==5 then
		if attr&ATTRIBUTE_WATER==0 then return end
		local h=e:GetHandler()
		local rct=Duel.GetNextPhaseCount(PHASE_STANDBY,1-tp)
		local e1=Effect.CreateEffect(h)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsAttackAbove,1000))
		e1:SetReset(RESET_PHASE|PHASE_STANDBY|RESET_OPPO_TURN,rct)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterHint(tp,id+100,PHASE_STANDBY,rct,id,5,nil,e1)
		Duel.RegisterHint(1-tp,id+100,PHASE_STANDBY,rct,id,5,nil,e1)
	
	elseif d8==6 then
		if attr&ATTRIBUTE_WATER==0 then return end
		local g=Duel.Group(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
		if #g==0 then return end
		Duel.HintMessage(tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,#g,nil)
		Duel.HintSelection(sg)
		if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
			local ct=Duel.GetGroupOperatedByThisEffect(e):FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
			if ct>0 then
				Duel.Damage(tp,ct*1000,REASON_EFFECT)
			end
		end
	end
	
	if d4==4 then
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE|PHASE_END,0,1,(8<<16)|d8)
	end
end

--D7
function s.d7info(d7,e,tp,attr,possible)
	if not possible then
		if attr&ATTRIBUTE_WIND==0 then return end
	end
	
	local cat=s.EffectCategories[7][d7]
	if cat~=0 then
		e:SetCategory(e:GetCategory()|cat)
	end
	info=possible and Duel.SetPossibleOperationInfo or Duel.SetOperationInfo
	if d7==1 then
		info(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
	elseif d7==2 then
		if possible then e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_SPSUMMON) end
		info(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif e7==3 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
	end
end
function s.activationLegalityd7(c,d4,d7,e,tp)
	if not c:IsAttribute(ATTRIBUTE_WIND) then return end
	if d7==1 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(7<<16)|1)) and Duel.IsExists(false,s.d7filter_1,tp,LOCATION_GRAVE,0,1,nil)
	elseif d7==2 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(7<<16)|2))
			and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.d7filter_2,tp,LOCATION_GRAVE,0,1,nil,e,tp,tp)
	elseif d7==3 then
		if not ((d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(7<<16)|3)) and Duel.GetMZoneCount(1-tp,nil,tp)>0) then return false end
		local g=Duel.GetDeck(1-tp)
		local ct=#g
		if ct<=0 then return false end
		if ct==1 and Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REVERSE_DECK) then
			local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
			return tc:IsMonster() and tc:IsCanBeSpecialSummoned(e,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		else
			return g:IsExists(s.d7filter_3,1,nil,tp)
		end
	elseif d7==4 then
		if not ((d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(7<<16)|4)) and Duel.GetMZoneCount(1-tp,nil,tp)>0) then return false end
		local g=Duel.GetDeck(1-tp)
		local ct=#g
		if ct<=0 then return false end
		if ct==1 and Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REVERSE_DECK) then
			local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
			return tc:IsST() and tc:IsSSetable()
		else
			return g:IsExists(s.d7filter_4,1,nil,tp)
		end
	elseif d7==5 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(7<<16)|5))
			and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.d7filter_5,tp,LOCATION_HAND,0,1,nil,tp)
	elseif d7==6 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(7<<16)|6))
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExists(false,s.d7filter_6,tp,LOCATION_HAND,0,1,nil,tp)
	end
	return false
end
function s.d7filter_1(c)
	return c:IsST() and not c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function s.d7filter_2(c,e,tp,p)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,p)
end
function s.d7filter_3(c,tp)
	return Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEDOWN_DEFENSE,1-tp,c)
end
function s.d7filter_4(c,tp)
	return Duel.IsPlayerCanSSet(tp,c)
end
function s.d7filter_5(c,tp)
	return c:IsMonster() and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_MZONE)
end
function s.d7filter_6(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function s.d7operation(d4,d7,e,tp,attr)
	if attr&ATTRIBUTE_WIND==0 or (d4==4 and Duel.PlayerHasFlagEffectLabel(tp,id+100,(7<<16)|d7)) then return end
	
	if d7==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.d7filter_1),tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
		end
	
	elseif d7==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		local g=Duel.SelectMatchingCard(tp,s.d7filter_2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		end
	
	elseif d7==3 then
		local g=Duel.GetDeck(1-tp)
		if #g==0 then return end
		Duel.ConfirmCards(tp,g)
		if Duel.GetMZoneCount(1-tp,nil,tp)>0 and g:IsExists(s.d7filter_2,1,nil,e,tp,1-tp) then
			Duel.HintMessage(tp,HINTMSG_SPSUMMON)
			local tc=g:FilterSelect(tp,s.d7filter_2,1,1,nil,e,tp,1-tp)
			if tc then
				Duel.SpecialSummonRedirect(e,tc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			end
		end
	
	elseif d7==4 then
		local g=Duel.GetDeck(1-tp)
		if #g==0 then return end
		Duel.ConfirmCards(tp,g)
		if g:IsExists(s.d7filter_1,1,nil) then
			Duel.HintMessage(tp,HINTMSG_SET)
			local tc=g:FilterSelect(tp,s.d7filter_1,1,1,nil)
			if tc then
				Duel.SSetAndRedirect(tp,tc,e)
			end
		end
	
	elseif d7==5 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		local g=Duel.SelectMatchingCard(tp,s.d7filter_5,tp,LOCATION_HAND,0,1,1,nil,tp)
		if #g>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		end
	
	elseif d7==6 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
		local g=Duel.SelectMatchingCard(tp,s.d7filter_6,tp,LOCATION_HAND,0,1,1,nil,tp)
		if #g>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP_ATTACK,true)
		end
	end
	
	if d4==4 then
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE|PHASE_END,0,1,(7<<16)|d7)
	end
end

--D6
function s.d6info(d6,e,tp,attr,lv,atk,def,typ,possible)
	local cat=s.EffectCategories[6][d6]
	if cat~=0 then
		e:SetCategory(e:GetCategory()|cat)
	end
	info=possible and Duel.SetPossibleOperationInfo or Duel.SetOperationInfo
	if d6==2 then
		if not possible and attr&ATTRIBUTE_DARK==0 then return end
		e:SetProperty(e:GetProperty()|EFFECT_FLAG_CARD_TARGET)
		if not possible then
			local tc=Duel.Select(HINTMSG_TARGET,true,tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
			tc:RegisterFlagEffect(id+200,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1,e:GetFieldID())
		end
	elseif d6==3 then
		local v=def
		if type(v)=="table" then
			for i,val in ipairs(v) do
				if i==1 or val<v then
					v=val
				end
			end
		end
		if not possible and v>1000 then return end
		info(0,CATEGORY_DAMAGE,nil,0,1-tp,v)
	elseif e6==4 then
		local v=lv
		if type(v)=="table" then
			for i,val in ipairs(v) do
				v=val
				if val==5 then
					break
				end
			end
		end
		if not possible and v~=5 then return end
		Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif d6==6 then
		local v=atk
		if type(v)=="table" then
			for i,val in ipairs(v) do
				if i==1 or val>v then
					v=val
				end
			end
		end
		if not possible and v<2000 then return end
		e:SetProperty(e:GetProperty()|EFFECT_FLAG_CARD_TARGET)
		if not possible then
			local tc=Duel.Select(HINTMSG_TARGET,true,tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
			tc:RegisterFlagEffect(id+400,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1,e:GetFieldID())
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
		end
	end
end
function s.activationLegalityd6(c,d4,d6,e,tp)
	if d6==1 then
		return c:IsAttribute(ATTRIBUTE_DARK) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(6<<16)|1)) and (Duel.IsAbleToEnterBP() or Duel.IsBattlePhase())
	elseif d6==2 then
		return d4~=6 and c:IsAttribute(ATTRIBUTE_DARK) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(6<<16)|2))
			and Duel.IsExists(true,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	elseif d6==3 then
		return c:IsMonster() and c:IsDefenseBelow(1000) and c:IsDefenseAbove(1) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(6<<16)|3))
	elseif d6==4 then
		return c:IsLevel(5) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(6<<16)|4))
	elseif d6==5 then
		return c:IsAttribute(ATTRIBUTE_DARK) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(6<<16)|5))
	elseif d6==6 then
		return c:IsAttackAbove(2000) and (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(6<<16)|6))
			and Duel.IsExists(true,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
	end
	return false
end
function s.d6operation(d4,d6,e,tp,attr,lv,atk,def,typ)
	if d4==4 and Duel.PlayerHasFlagEffectLabel(tp,id+100,(6<<16)|d6) then return end
	if d6==1 then
		if attr&ATTRIBUTE_DARK==0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,Duel.GetTurnPlayer())
		
	elseif d6==2 then
		if d4==6 then return end
		local tc
		if d4>3 then
			tc=Duel.Select(HINTMSG_TARGET,true,tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		else
			tc=Duel.GetTargetCards():Filter(Card.HasFlagEffectLabel,nil,id+200,e:GetFieldID()):GetFirst()
		end
		if tc and tc:IsFaceup() then
			tc:ChangeATK(0,true,{e:GetHandler(),true})
		end
	
	elseif d6==3 then
		if typ&TYPE_MONSTER==0 or typ&TYPE_LINK>0 then return end
		local v0=def
		if type(def)=="table" then
			for i,val in ipairs(def) do
				if i==1 or val<v0 then
					v0=val
				end
			end
		end
		local p,v=1-tp,v0
		if v>1000 then return end
		Duel.Damage(p,v,REASON_EFFECT)
	
	elseif d6==4 then
		local v=lv
		if type(v)=="table" then
			for i,val in ipairs(v) do
				v=val
				if val==5 then
					break
				end
			end
		end
		if v~=5 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:Desc(2,id)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE|PHASE_END)
		e1:OPT()
		e1:SetOperation(s.d6spop)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	
	elseif d6==5 then
		if attr&ATTRIBUTE_DARK==0 then return end
		local h=e:GetHandler()
		local e1=Effect.CreateEffect(h)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_PHASE|PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetCondition(s.d6limcon1)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(h)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetReset(RESET_PHASE|PHASE_END)
		e2:SetTargetRange(0,1)
		e2:SetCondition(s.d6limcon2)
		Duel.RegisterEffect(e2,tp)
		local ge1=Effect.CreateEffect(h)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(s.d6update)
		ge1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(ge1,tp)
	
	elseif d6==6 then
		if d4==6 then return end
		local tc
		if d4>3 then
			tc=Duel.Select(HINTMSG_RTOHAND,true,tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		else
			tc=Duel.GetTargetCards():Filter(Card.HasFlagEffectLabel,nil,id+400,e:GetFieldID()):GetFirst()
		end
		if tc and tc:IsControler(1-tp) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
	
	if d4==4 then
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE|PHASE_END,0,1,(6<<16)|d6)
	end
end
function s.d6spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExists(false,aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,LOCATION_GRAVE,0,1,nil,e,0,tp,false,false) or not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,LOCATION_GRAVE,0,1,1,nil,e,0,tp,false,false)
	if #g>0 then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.d6limcon1(e)
	local p=e:GetHandlerPlayer()
	return not Duel.PlayerHasFlagEffect(p,id+300) or Duel.GetFlagEffectLabel(p,id+300)<1000
end
function s.d6limcon2(e)
	local p=1-e:GetHandlerPlayer()
	return not Duel.PlayerHasFlagEffect(p,id+300) or Duel.GetFlagEffectLabel(p,id+300)<1000
end
function s.d6update(e,tp,eg,ep,ev,re,r,rp)
	Duel.UpdateFlagEffectLabel(ep,id+300,-1000)
end

--D5
function s.d5info(d5,e,tp,attr,possible)
	if not possible then
		if attr&ATTRIBUTE_LIGHT==0 then return end
	end
	local cat=s.EffectCategories[5][d5]
	if cat~=0 then
		e:SetCategory(e:GetCategory()|cat)
	end
	info=possible and Duel.SetPossibleOperationInfo or Duel.SetOperationInfo
	if d5==1 then
		info(0,CATEGORY_TOHAND,nil,2,PLAYER_ALL,LOCATION_HAND)
	elseif d5==4 then
		info(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif d5>4 then
		local p=d5==5 and tp or 1-tp
		info(0,CATEGORY_HANDES,nil,0,p,1)
	end
end
function s.activationLegalityd5(c,d4,d5,e,tp)
	if not c:IsAttribute(ATTRIBUTE_LIGHT) then return false end
	if d5==1 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(5<<16)|1)) and Duel.GetHandCount(1-tp)>0 
	elseif d5==2 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(5<<16)|2))
	elseif d5==3 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(5<<16)|3))
	elseif d5==4 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(5<<16)|4)) and Duel.IsExists(false,s.d5filter4_1,tp,LOCATION_HAND,0,1,nil,tp)
	elseif d5==5 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(5<<16)|5)) and Duel.IsExists(false,Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
	elseif d5==6 then
		return (d4~=4 or not Duel.PlayerHasFlagEffectLabel(tp,id+100,(5<<16)|6)) and Duel.IsExists(false,Card.IsDiscardable,tp,0,LOCATION_HAND,1,nil,REASON_EFFECT)
	end
	return false
end
function s.d5filter4_1(c,tp)
	return not c:IsPublic() and Duel.IsExists(false,s.d5filter4_2,tp,LOCATION_DECK,0,1,nil,c:GetType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP))
end
function s.d5filter4_2(c,typ)
	return c:IsType(typ) and c:IsAbleToHand()
end
function s.d5operation(d4,d5,e,tp,attr)
	if attr&ATTRIBUTE_LIGHT==0 or (d4==4 and Duel.PlayerHasFlagEffectLabel(tp,id+100,(5<<16)|d5)) then return end
	if d5==1 then
		local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #g2==0 then return end
		Duel.ConfirmCards(tp,g2)
		if #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ag1=g1:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local ag2=g2:Select(tp,1,1,nil)
			Duel.SendtoHand(ag1,1-tp,REASON_EFFECT,tp)
			Duel.SendtoHand(ag2,tp,REASON_EFFECT,tp)
		end
		
	elseif d5==2 or d5==3 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_PUBLIC)
		if d5==2 then
			e1:SetTargetRange(LOCATION_HAND,0)
		else
			e1:SetTargetRange(0,LOCATION_HAND)
		end
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	
	elseif d5==4 then
		local g=Duel.ForcedSelect(HINTMSG_CONFIRM,false,tp,s.d5filter4_1,tp,LOCATION_HAND,0,1,1,nil,tp)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
			local tg=Duel.Select(HINTMSG_ATOHAND,false,tp,s.d5filter4_2,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst():GetType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP))
			if #tg>0 then
				Duel.Search(tg)
			end
		end
	
	elseif d5>4 then
		local p=d5==5 and tp or 1-tp
		Duel.DiscardHand(p,Card.IsDiscardable,1,1,REASON_EFFECT|REASON_DISCARD,nil,REASON_EFFECT)
	end
	
	if d4==4 then
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE|PHASE_END,0,1,(5<<16)|d5)
	end
end

function s.d2condition(d2)
	if d2==3 then
		return	function(e,tp,eg,ep,ev,re,r,rp)
					return re:GetHandler()==e:GetHandler() and re:GetLabelObject()==e
				end
	elseif d2==4 then
		return	function(e,tp,eg,ep,ev,re,r,rp)
					return rp==1-tp
				end
	else
		return aux.TRUE
	end
end
function s.d2target(d2)
	if d2==1 then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return true end
					Duel.SetTargetPlayer(tp)
					Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,math.max(0,Duel.GetLP(tp)-1000))
				end
				
	elseif d2==2 then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return true end
					Duel.SetTargetPlayer(1-tp)
					Duel.SetTargetParam(1000)
					Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
				end
	
	elseif d2==3 then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return true end
					Duel.SetTargetPlayer(tp)
					Duel.SetTargetParam(1000)
					Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
				end
	
	elseif d2==4 then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return true end
					Duel.SetTargetPlayer(1-tp)
					local val=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)*1000
					if val>0 then
						Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
					else
						Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
					end
				end
	end
end
function s.d2operation(d2)
	if d2==1 then
		return	function(e,tp,eg,ep,ev,re,r,rp)
					local p=Duel.GetTargetPlayer()
					local val=Duel.GetLP(tp)-1000
					if val>0 then
						Duel.Damage(p,val,REASON_EFFECT)
					end
				end
				
	elseif d2==2 then
		return	function(e,tp,eg,ep,ev,re,r,rp)
					local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
					Duel.Damage(p,val,REASON_EFFECT)
				end
	
	elseif d2==3 then
		return	function(e,tp,eg,ep,ev,re,r,rp)
					local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
					Duel.Recover(p,val,REASON_EFFECT)
				end
				
	elseif d2==4 then
		return	function(e,tp,eg,ep,ev,re,r,rp)
					local p=Duel.GetTargetPlayer()
					local val=Duel.GetFieldGroupCount(p,LOCATION_ONFIELD,0)*1000
					if val>0 then
						Duel.Damage(p,val,REASON_EFFECT)
					end
				end
				
	end
end

function s.d3condition(d3,isFastEffect)
	if d3==2 or d3==4 then
		return 	function(e,tp,eg,ep,ev,re,r,rp)
					return Duel.IsMainPhase() and (isFastEffect or Duel.IsTurnPlayer(tp))
				end
	elseif d3==5 then
		return 	function(e,tp,eg,ep,ev,re,r,rp)
					return Duel.IsBattlePhase() and (isFastEffect or (Duel.IsTurnPlayer(tp) and Duel.GetCurrentChain()==0))
				end
	else
		return aux.TRUE
	end
end
function s.atfilter(c,d3,xyzc,e,tp)
	return (d3==3 or c:IsMonster()) and c:IsCanBeAttachedTo(xyzc,e,tp,REASON_EFFECT)
end
function s.d3target(d3)
	if d3<=3 then
		local min=d3==2 and 2 or 1
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then
						local c=e:GetHandler()
						local p=d3==3 and 1-tp or tp
						if d3==3 and Duel.IsPlayerAffectedByEffect(p,EFFECT_REVERSE_DECK) and Duel.GetDeckCount(p)==1 and not s.atfilter(Duel.GetDecktopGroup(p,1):GetFirst(),0,c,e,tp) then
							return false
						end
						return c:IsType(TYPE_XYZ) and Duel.IsExists(false,s.atfilter,p,LOCATION_DECK,0,min,nil,d3,c,e,tp)
					end
				end
		
	elseif d3<6 then
		local loc=d3==4 and LOCATION_HAND or LOCATION_EXTRA
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then
						local c=e:GetHandler()
						return c:IsType(TYPE_XYZ) and Duel.IsExists(false,Card.IsCanBeAttachedTo,tp,0,loc,1,nil,c,e,tp,REASON_EFFECT)
					end
				end
	else
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then
						local c=e:GetHandler()
						local g=Duel.GetDecktopGroup(tp,10)
						return c:IsType(TYPE_XYZ) and #g>=10 and g:FilterCount(Card.IsCanBeAttachedTo,nil,c,e,tp,REASON_EFFECT)>0
					end
				end
	end
end
function s.d3operation(d3)
	if d3<=3 then
		local min=d3==2 and 2 or 1
		return	function(e,tp,eg,ep,ev,re,r,rp)
						local c=e:GetHandler()
						if c:IsRelateToChain() and c:IsType(TYPE_XYZ) then
							local p=d3==3 and 1-tp or tp
							local g=d3==1 and Duel.Select(HINTMSG_XMATERIAL,false,tp,s.atfilter,p,LOCATION_DECK,0,1,1,nil,d3,c,e,tp) or Duel.GetDeck(p):Filter(s.atfilter,nil,0,c,e,tp):RandomSelect(tp,min)
							if #g>=min then
								Duel.Attach(g,c,false,e,REASON_EFFECT,tp)
							end
						end
					end
					
	elseif d3<6 then
		local loc=d3==4 and LOCATION_HAND or LOCATION_EXTRA
		return	function(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetHandler()
					if c:IsRelateToChain() and c:IsType(TYPE_XYZ) then
						local g=Duel.GetFieldGroup(tp,0,loc)
						if #g>0 then
							Duel.ConfirmCards(tp,g)
							local sg=g:FilterSelect(tp,Card.IsCanBeAttachedTo,1,1,nil,c,e,tp,REASON_EFFECT)
							if #sg>0 then
								Duel.Attach(sg,c,false,e,REASON_EFFECT,tp)
							end
						end
					end
				end
	else
		return	function(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetHandler()
					if c:IsRelateToChain() and c:IsType(TYPE_XYZ) then
						Duel.ConfirmDecktop(tp,10)
						local g=Duel.GetDecktopGroup(tp,10)
						if #g>0 then
							local sg=g:Filter(Card.IsMonster,nil):Filter(Card.IsCanBeAttachedTo,nil,c,e,tp,REASON_EFFECT)
							Duel.DisableShuffleCheck()
							local ct=0
							if #sg>0 then
								ct=Duel.Attach(sg,c,false,e,REASON_EFFECT,tp)
							end
							if #g-ct>0 then
								Duel.ShuffleDeck(tp)
							end
						end
					end
				end
	end
end