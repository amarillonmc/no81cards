--[[
键★断片 - 恭介 〔将一切日常化为任务的领袖〕
K.E.Y Fragments - Kyousuke 〔Leader Who Turns Days Into Missions〕
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
	STICKERS_TABLE[STICKER_LEADER_WHO_TURNS_DAYS_INTO_MISSIONS] = {id,0}
	STICKERS_TABLE[STICKER_LOST_TO_KYOUSUKE] 					= {id,6}
	aux.SpawnGlitchyHelper(GLITCHY_HELPER_STICKER_FLAG)
	aux.RegisterKeyFragmentStickerContinuous(c,id,STICKER_LEADER_WHO_TURNS_DAYS_INTO_MISSIONS,STICKER_LOST_TO_KYOUSUKE)
	
	--[[If this card you control is destroyed and sent to the GY: You can place 1 "Leader Who Turns Days Into Missions" Sticker on 1 FIRE "K.E.Y" monster you control.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(11)
	e1:SetCustomCategory(CATEGORY_PLACE_STICKER)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetFunctions(s.skcon,nil,s.sktg,s.skop)
	c:RegisterEffect(e1)
	
	--[[A monster with this Sticker gains the following effect.
	● Once per turn: You can add 1 FIRE "K.E.Y Fragments" monster, or 1 "K.E.Y L.B.O" card, from your Deck to your hand. ]]
	aux.RegisterStickerEffect(STICKER_LEADER_WHO_TURNS_DAYS_INTO_MISSIONS,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetCategory(CATEGORIES_SEARCH)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:OPT()
		e1:SetTarget(s.thtg)
		e1:SetOperation(s.thop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
	
	--[[A card with this Sticker gains the following effect.
	● FIRE "K.E.Y" monsters your opponent controls can attack directly.]]
	aux.RegisterStickerEffect(STICKER_LOST_TO_KYOUSUKE,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetTarget(s.atktg)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
end

--E1
function s.skcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY)
end
function s.skfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanAddSticker(STICKER_LEADER_WHO_TURNS_DAYS_INTO_MISSIONS,1,e,tp,REASON_EFFECT)
end
function s.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExists(false,s.skfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.SetCustomOperationInfo(0,CATEGORY_PLACE_STICKER,nil,1,tp,LOCATION_MZONE)
end
function s.skop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_FACEUP,false,tp,s.skfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		tc:AddSticker(STICKER_LEADER_WHO_TURNS_DAYS_INTO_MISSIONS,1,e,tp,REASON_EFFECT)
	end
end

--S1
function s.thfilter(c)
	return ((c:IsSetCard(ARCHE_KEY_FRAGMENTS) and c:IsMonster()) or c:IsSetCard(ARCHE_KEY_LBO)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--S2
function s.atktg(e,c)
	return c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE)
end