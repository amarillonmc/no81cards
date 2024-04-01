--[[
键★断片 - 来谷 〔有点淘气的大姐姐〕
K.E.Y Fragments - Kurugaya 〔A tad Mischievous Anego〕
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
	STICKERS_TABLE[STICKER_A_TAD_MISCHIEVOUS_ANEGO]	= {id,0}
	STICKERS_TABLE[STICKER_LOST_TO_KURUGAYA] 		= {id,6}
	aux.SpawnGlitchyHelper(GLITCHY_HELPER_STICKER_FLAG)
	aux.RegisterKeyFragmentStickerQE(c,950,STICKER_A_TAD_MISCHIEVOUS_ANEGO)
	aux.RegisterKeyFragmentStickerContinuous(c,id,STICKER_A_TAD_MISCHIEVOUS_ANEGO,STICKER_LOST_TO_KURUGAYA)
	
	--[[A monster with this Sticker gains the following effects:
	● Once per turn: You can target 1 FIRE "K.E.Y Fragments" monster in your GY; shuffle that target into the Deck, and if you do,
	add 1 FIRE "K.E.Y Fragments" monster with a different name from your Deck to your hand.]]
	aux.RegisterStickerEffect(STICKER_A_TAD_MISCHIEVOUS_ANEGO,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetCategory(CATEGORY_TODECK|CATEGORIES_SEARCH)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:OPT()
		e1:SetTarget(s.thtg)
		e1:SetOperation(s.thop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
	
	--[[A card with this Sticker gains the following effect.
	● During the Main Phase (Quick Effect): Your opponent can activate this effect; they send 1 FIRE "K.E.Y Fragments" monster from their hand to the GY,
	then they target 1 monster you control; negate its effects, until the end of this turn.]]
	aux.RegisterStickerEffect(STICKER_LOST_TO_KURUGAYA,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetDescription(aux.Stringid(id,6))
		e1:SetCategory(CATEGORY_DISABLE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_BOTH_SIDE|EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetRelevantTimings()
		e1:SetCondition(s.discon)
		e1:SetCost(s.discost)
		e1:SetTarget(s.distg)
		e1:SetOperation(s.disop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
end

--E1
function s.tdfilter(c,tp,ignore)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(ARCHE_KEY_FRAGMENTS) and c:IsAbleToDeck() and (ignore or Duel.IsExists(false,s.thfilter,tp,LOCATION_DECK,0,1,c,{c:GetCode()}))
end
function s.thfilter(c,codes)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(ARCHE_KEY_FRAGMENTS) and c:IsAbleToHand() and not c:IsCode(table.unpack(codes))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc,tp,false)
	end
	if chk==0 then
		return Duel.IsExists(true,s.tdfilter,tp,LOCATION_GRAVE,0,1,nil,tp,false)
	end
	local g=Duel.Select(HINTMSG_TODECK,true,tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp,false)
	Duel.SetCardOperationInfo(g,CATEGORY_TODECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and s.tdfilter(tc,tp,true) then
		local codes={tc:GetCode()}
		if Duel.ShuffleIntoDeck(tc)>0 then
			local g=Duel.Select(HINTMSG_ATOHAND,false,tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,codes)
			if #g>0 then
				Duel.Search(g,tp)
			end
		end
	end
end

--E2
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and tp==1-e:GetHandlerPlayer()
end
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(ARCHE_KEY_FRAGMENTS) and c:IsAbleToGraveAsCost()
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.NegateMonsterFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetCardOperationInfo(g,CATEGORY_DISABLE)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToChain() and tc:IsCanBeDisabledByEffect(e) then
		Duel.Negate(tc,e,RESET_PHASE|PHASE_END,nil,nil,TYPE_MONSTER)
	end
end