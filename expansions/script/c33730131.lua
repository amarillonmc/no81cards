--[[
键★断片 - 理树 〔过着异常多彩青春的普通少年〕
K.E.Y Fragments - Riki 〔Ordinary Boy〕
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
	STICKERS_TABLE[STICKER_ORDINARY_BOY] 	= {id,0}
	STICKERS_TABLE[STICKER_LOST_TO_RIKI] 	= {id,6}
	aux.SpawnGlitchyHelper(GLITCHY_HELPER_STICKER_FLAG)
	aux.RegisterKeyFragmentStickerContinuous(c,id,STICKER_ORDINARY_BOY,STICKER_LOST_TO_RIKI)
	
	--[[You can send this card you control with 4+ different Stickers to the GY; Special Summon 1 "K.E.Y Memoria -  Hanabi" from your Extra Deck,
	ignoring its Summoning conditions, and if you do, transfer all Stickers of this card to that monster.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(11)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCustomCategory(CATEGORY_PLACE_STICKER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetFunctions(nil,aux.DummyCost,s.sptg,s.spop)
	c:RegisterEffect(e1)
	
	--[[A monster with this Sticker gains the following effect.
	● Before damage calculation, if this card battles: You can reveal any number of FIRE "K.E.Y Fragments" monsters in your hand; until the end of this turn, this card gains 300 ATK/DEF for each card you revealed and for each FIRE "K.E.Y" monster you currently control.]]
	aux.RegisterStickerEffect(STICKER_ORDINARY_BOY,function(owner)
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
	● During the Standby Phase: Your opponent can activate this effect; they take 1 "K.E.Y L.B.O" card from their Deck or GY, and either place it on the field, face-up, or add it into their hand.]]
	aux.RegisterStickerEffect(STICKER_LOST_TO_RIKI,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetDescription(aux.Stringid(id,6))
		e1:SetCategory(CATEGORIES_SEARCH|CATEGORY_GRAVE_ACTION)
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
	return c:IsCode(CARD_KEY_MEMORIA_HANABI) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(c,tp,nil,sc)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return e:IsCostChecked() and c:IsAbleToGraveAsCost() and c:GetStickerClassCount()>=4 and Duel.IsExists(false,s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
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
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return e:IsCostChecked() and c:HasAttack() and Duel.IsExists(false,s.rvfilter,tp,LOCATION_HAND,0,1,nil)
	end
	local g=Duel.Select(HINTMSG_CONFIRM,false,tp,s.rvfilter,tp,LOCATION_HAND,0,1,99,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.SetTargetParam(#g)
		local fg=Duel.Group(s.filter,tp,LOCATION_MZONE,0,nil)
		Duel.SetCustomOperationInfo(0,CATEGORIES_ATKDEF,c,1,tp,LOCATION_MZONE,(#g+#fg)*300)
	end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTargetParam()
	if not ct then return end
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then
		local fg=Duel.Group(s.filter,tp,LOCATION_MZONE,0,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue((ct+#fg)*300)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_DISABLE|RESET_PHASE|PHASE_END)
		c:RegisterEffect(e1)
		e1:UpdateDefenseClone(c)
	end
end

--S2
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==1-e:GetHandlerPlayer()
end
function s.actfilter(c,tp)
	if not c:IsSetCard(ARCHE_KEY_LBO) or not c:IsType(TYPE_CONTINUOUS) then return false end
	return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)) or c:IsAbleToHand()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExists(false,s.actfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_OPERATECARD,false,tp,aux.Necro(s.actfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,tp)
	if #g>0 then
		local c=g:GetFirst()
		local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
		local b2=c:IsAbleToHand()
		local opt=aux.Option(tp,id,15,b1,b2)
		if opt==0 then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		elseif opt==1 then
			Duel.Search(c,tp)
		end
	end
end