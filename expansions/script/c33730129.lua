--[[
键★断片 - 美鱼 〔打着太阳伞的文静天然素材〕
K.E.Y Fragments - Mio 〔Parasol-Holding Silent Beauty〕
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
	STICKERS_TABLE[STICKER_PARASOL_HOLDING_SILENT_BEAUTY] 	= {id,0}
	STICKERS_TABLE[STICKER_LOST_TO_MIO] 					= {id,6}
	aux.SpawnGlitchyHelper(GLITCHY_HELPER_STICKER_FLAG)
	aux.RegisterKeyFragmentStickerQE(c,300,STICKER_PARASOL_HOLDING_SILENT_BEAUTY)
	aux.RegisterKeyFragmentStickerContinuous(c,id,STICKER_PARASOL_HOLDING_SILENT_BEAUTY,STICKER_LOST_TO_MIO)
	
	--[[A monster with this Sticker gains the following effects.
	● FIRE "K.E.Y" monsters cannot be destroyed by battle.
	● Once per turn: You can reveal any number of FIRE "K.E.Y Fragment" monsters with different names in your hand; all FIRE "K.E.Y" monsters you currently control gain 300 ATK for each card you revealed.]]
	aux.RegisterStickerEffect(STICKER_PARASOL_HOLDING_SILENT_BEAUTY,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(s.indfilter)
		e1:SetValue(1)
		local e2=Effect.CreateEffect(owner)
		e2:SetDescription(aux.Stringid(id,0))
		e2:SetCategory(CATEGORY_ATKCHANGE)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:OPT()
		e2:SetTarget(s.atktg)
		e2:SetOperation(s.atkop)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1,e2
	end
	)
	
	--[[A card with this Sticker gains the following effect.
	● All monsters you control lose 800 ATK.]]
	aux.RegisterStickerEffect(STICKER_LOST_TO_MIO,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(-800)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
end

--E1
function s.indfilter(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(ARCHE_KEY)
end

--E2
function s.rvfilter(c)
	return c:IsMonster() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(ARCHE_KEY_FRAGMENTS) and not c:IsPublic()
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(ARCHE_KEY) and c:HasAttack()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.Group(s.rvfilter,tp,LOCATION_HAND,0,nil)
	local atkg=Duel.Group(s.atkfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		return e:IsCostChecked() and #g>0 and #atkg>0
	end
	local rg=g:SelectSubGroup(tp,aux.dncheck,false,1,#g)
	if #rg>0 then
		Duel.ConfirmCards(1-tp,rg)
		local val=300*#rg
		Duel.SetTargetParam(val)
		Duel.SetCustomOperationInfo(0,CATEGORY_ATKCHANGE,atkg,#atkg,tp,LOCATION_MZONE,val)
	end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=Duel.GetTargetParam()
	if not val then return end
	local atkg=Duel.Group(s.atkfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(atkg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end