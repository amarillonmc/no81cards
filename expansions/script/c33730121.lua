--[[
键★断片 - 小毬 〔软扑扑的童话少女〕
K.E.Y Fragments - Komari 〔Peerlessly Cute Fairy Tale Girl〕
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_KEYFRAGMENT_LOADED then
	GLITCHYLIB_KEYFRAGMENT_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
Duel.LoadScript("glitchylib_helper.lua")
function s.initial_effect(c)
	STICKERS_TABLE[STICKER_PEERLESSLY_CUTE_FAIRY_TALE_GIRL] 	= {id,0}
	STICKERS_TABLE[STICKER_LOST_TO_KOMARI] 						= {id,6}
	aux.SpawnGlitchyHelper(GLITCHY_HELPER_STICKER_FLAG)
	aux.RegisterKeyFragmentStickerQE(c,400,STICKER_PEERLESSLY_CUTE_FAIRY_TALE_GIRL)
	aux.RegisterKeyFragmentStickerContinuous(c,id,STICKER_PEERLESSLY_CUTE_FAIRY_TALE_GIRL,STICKER_LOST_TO_KOMARI)
	
	--[[A monster with this sticker gains the following effect:
	● Before damage calculation, if this card battles a monster, gain LP equal to that monster's ATK.]]
	aux.RegisterStickerEffect(STICKER_PEERLESSLY_CUTE_FAIRY_TALE_GIRL,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetCategory(CATEGORY_RECOVER)
		e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EVENT_BATTLE_CONFIRM)
		e1:SetCondition(s.lpcon)
		e1:SetOperation(s.lpop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
	
	--[[A card with this Sticker gains the following effect.
	● During your Standby Phase: Your opponent can activate this effect; they add 1 FIRE "K.E.Y Fragments" monster from their Deck to their hand,
	and if they do, you gain LP equal to the ATK of that monster.]]
	aux.RegisterStickerEffect(STICKER_LOST_TO_KOMARI,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetCategory(CATEGORIES_SEARCH|CATEGORY_RECOVER)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_BOTH_SIDE|EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
		e1:SetRange(LOCATION_ONFIELD)
		e1:OPT()
		e1:SetCondition(aux.TurnPlayerCond(1))
		e1:SetTarget(s.thtg)
		e1:SetOperation(s.thop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
end

--E1
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsLocation(LOCATION_MZONE) and c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() and bc:IsControler(1-tp) and bc:IsAttackAbove(1)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	Duel.Hint(HINT_CARD,0,id)
	Duel.Recover(tp,bc:GetAttack(),REASON_EFFECT)
end

--E2
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExists(false,s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local tc=Duel.Select(HINTMSG_ATOHAND,false,tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SearchAndCheck(tc,tp) then
		Duel.Recover(1-tp,tc:GetAttack(),REASON_EFFECT)
	end
end