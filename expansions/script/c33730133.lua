--[[
键★断片 - 铃 〔不擅长与他人交流的高贵小猫〕
K.E.Y Fragments - Rin 〔Prideful Kitten〕
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
	STICKERS_TABLE[STICKER_PRIDEFUL_KITTEN] 	= {id,0}
	STICKERS_TABLE[STICKER_LOST_TO_RIN] 		= {id,6}
	aux.SpawnGlitchyHelper(GLITCHY_HELPER_STICKER_FLAG)
	aux.RegisterKeyFragmentStickerContinuous(c,id,STICKER_PRIDEFUL_KITTEN,STICKER_LOST_TO_RIN)
	
	--[[You can send this card you control with 3+ different Stickers to the GY; Special Summon 1 "K.E.Y Memoria - Just One Magic Word" from your Extra Deck,
	ignoring its Summoning conditions, and if you do, place all Stickers that were on this card on that monster.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(11)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCustomCategory(CATEGORY_PLACE_STICKER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetFunctions(nil,aux.DummyCost,s.sptg,s.spop)
	c:RegisterEffect(e1)
	
	--[[A monster with this Sticker gains the following effect.
	● Before damage calculation, if this card battles: You can reveal any number of FIRE "K.E.Y Fragments" monsters in your hand; until the end of this turn,
	all monsters your opponent currently controls lose 300 ATK/DEF for each card you revealed and for each FIRE "K.E.Y" monster you currently control.]]
	aux.RegisterStickerEffect(STICKER_PRIDEFUL_KITTEN,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetCategory(CATEGORIES_ATKDEF)
		e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EVENT_BATTLE_CONFIRM)
		e1:SetCondition(s.atkcon)
		e1:SetCost(aux.DummyCost)
		e1:SetTarget(s.atktg)
		e1:SetOperation(s.atkop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
	
	--[[A card with this Sticker gains the following effect.
	● During the Standby Phase: Your opponent can activate this effect; they shuffle 1 FIRE "K.E.Y Fragments" monster from their GY into the Deck, and if they do, they draw 1 card. ]]
	aux.RegisterStickerEffect(STICKER_LOST_TO_RIN,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetDescription(aux.Stringid(id,6))
		e1:SetCategory(CATEGORY_TODECK|CATEGORY_DRAW)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_BOTH_SIDE|EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetCondition(s.discon)
		e1:SetTarget(s.distg)
		e1:SetOperation(s.disop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
end

--E1
function s.spfilter(c,e,tp,sc)
	return c:IsCode(CARD_KEY_MEMORIA_JUST_ONE_MAGIC_WORD) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(c,tp,nil,sc)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return e:IsCostChecked() and c:IsAbleToGraveAsCost() and c:GetStickerClassCount()>=3 and Duel.IsExists(false,s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
	end
	local stickers=c:GetAllStickers()
	e:SetLabel(table.unpack(stickers))
	Duel.SendtoGrave(c,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)>0 then
		local tc=g:GetFirst()
		local stickers={e:GetLabel()}
		for _,sticker in ipairs(stickers) do
			tc:AddSticker(sticker,1,e,tp,REASON_EFFECT)
		end
	end
end

--S1
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function s.rvfilter(c)
	return c:IsSetCard(ARCHE_KEY_FRAGMENTS) and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsPublic()
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:HasAttack()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.Group(s.atkfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then
		return e:IsCostChecked() and Duel.IsExists(false,s.rvfilter,tp,LOCATION_HAND,0,1,nil) and #sg>0
	end
	local g=Duel.Select(HINTMSG_CONFIRM,false,tp,s.rvfilter,tp,LOCATION_HAND,0,1,99,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.SetTargetParam(#g)
		local fg=Duel.Group(s.filter,tp,LOCATION_MZONE,0,nil)
		Duel.SetCustomOperationInfo(0,CATEGORIES_ATKDEF,sg,#sg,1-tp,LOCATION_MZONE,(#g+#fg)*-300)
	end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTargetParam()
	if not ct then return end
	local c=e:GetHandler()
	local fg=Duel.Group(s.filter,tp,LOCATION_MZONE,0,nil)
	local sg=Duel.Group(s.atkfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue((ct+#fg)*-300)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		tc:RegisterEffect(e1)
		e1:UpdateDefenseClone(c)
	end
end

--S2
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==1-e:GetHandlerPlayer()
end
function s.tdfilter(c)
	return c:IsSetCard(ARCHE_KEY_FRAGMENTS) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToDeck()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExists(false,s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_TODECK,false,tp,aux.Necro(s.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.ShuffleIntoDeck(g)>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end