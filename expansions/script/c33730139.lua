--[[
键★断片 - 谦吾 〔最强的男儿·真人的竞争对手〕
K.E.Y Fragments - Kengo 〔Masato's Strongest Rival〕
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
	STICKERS_TABLE[STICKER_MASATOS_STRONGEST_RIVAL]	= {id,0}
	STICKERS_TABLE[STICKER_LOST_TO_KENGO] 			= {id,6}
	aux.SpawnGlitchyHelper(GLITCHY_HELPER_STICKER_FLAG)
	aux.RegisterKeyFragmentStickerContinuous(c,id,STICKER_MASATOS_STRONGEST_RIVAL,STICKER_LOST_TO_KENGO)
	
	--[[When a FIRE "K.E.Y" monster you control is targeted by a card effect, or for an attack (Quick Effect): You can discard this card;
	negate that effect or attack, and if you do, destroy that card that targeted your monster, then place 1 "Masato's Strongest Rival" Sticker on the monster that was targeted.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(11)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCustomCategory(CATEGORY_PLACE_STICKER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.descon)
	e1:SetCost(aux.DiscardSelfCost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_DESTROY|CATEGORY_DISABLE)
	e2:SetCustomCategory(CATEGORY_PLACE_STICKER)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.descon2)
	e2:SetTarget(s.destg2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	
	--[[A monster with this Sticker gains the following effect.
	● Gains 800 ATK/DEF during the Battle Phase only.]]
	aux.RegisterStickerEffect(STICKER_MASATOS_STRONGEST_RIVAL,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(aux.BattlePhaseCond())
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		local e2=e1:UpdateDefenseClone(owner,true)
		return e1,e2
	end
	)
	
	--[[A card with this Sticker gains the following effects.
	● Monsters you control lose 500 ATK/DEF for each FIRE "K.E.Y" monster your opponent controls.
	● Change all monsters you control with 0 DEF to Defense Position.]]
	aux.RegisterStickerEffect(STICKER_LOST_TO_KENGO,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(s.atkval)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		local e2=e1:UpdateDefenseClone(owner,true)
		e2:SetTargetRange(LOCATION_MZONE,0)
		local e3=Effect.CreateEffect(owner)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_SET_POSITION)
		e3:SetRange(LOCATION_ONFIELD)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(s.distg)
		e3:SetValue(POS_FACEUP_DEFENSE)
		return e1,e2,e3
	end
	)
end

--E1
function s.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and s.tgfilter(d,tp)
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not Duel.IsChainDisablable(ev) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.tgfilter,1,nil,tp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local d,rc=Duel.GetAttackTarget(),Duel.GetAttacker()
	if rc:IsRelateToBattle() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
	end
	rc:RegisterFlagEffect(id,RESET_CHAIN,0,1,0)
	d:RegisterFlagEffect(id,RESET_CHAIN,0,1,1)
	Duel.SetTargetCard(Group.FromCards(rc,d))
	Duel.SetCustomOperationInfo(0,CATEGORY_PLACE_STICKER,d,1,tp,LOCATION_MZONE)
end
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return not rc:IsDisabled() end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if rc:IsDestructable() and rc:IsRelateToChain(ev) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(s.tgfilter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetCustomOperationInfo(0,CATEGORY_PLACE_STICKER,g,1,tp,LOCATION_MZONE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards()
	local a,d=g:Filter(Card.HasFlagEffectLabel,nil,id,0):GetFirst(),g:Filter(Card.HasFlagEffectLabel,nil,id,1):GetFirst()
	if a and a:IsRelateToBattle() and Duel.NegateAttack() and Duel.Destroy(a,REASON_EFFECT)~=0 and d and d:IsCanAddSticker(STICKER_MASATOS_STRONGEST_RIVAL,1,e,tp,REASON_EFFECT) then
		Duel.BreakEffect()
		d:AddSticker(STICKER_MASATOS_STRONGEST_RIVAL,1,e,tp,REASON_EFFECT)
	end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.NegateEffect(ev) and tc:IsRelateToChain(ev) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local g=Duel.GetTargetCards():Filter(Card.IsCanAddSticker,nil,STICKER_MASATOS_STRONGEST_RIVAL,1,e,tp,REASON_EFFECT)
		if #g>0 then
			if #g>1 then
				Duel.HintMessage(tp,HINTMSG_FACEUP)
				g=g:Select(tp,1,1,nil)
			end
			Duel.BreakEffect()
			g:GetFirst():AddSticker(STICKER_MASATOS_STRONGEST_RIVAL,1,e,tp,REASON_EFFECT)
		end
	end
end

--S2
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_MZONE,nil)*-500
end
function s.distg(e,c)
	return c:IsDefense(0)
end