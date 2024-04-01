--[[
键★断片 - 真人 〔让人恨不起来的肌肉笨蛋一根筋〕
K.E.Y Fragments - Masato 〔Lovable Straight Muscle Idiot〕
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
	STICKERS_TABLE[STICKER_LOVABLE_STRAIGHT_MUSCLE_IDIOT]	= {id,0}
	STICKERS_TABLE[STICKER_LOST_TO_MASATO] 					= {id,6}
	aux.SpawnGlitchyHelper(GLITCHY_HELPER_STICKER_FLAG)
	aux.RegisterKeyFragmentStickerContinuous(c,id,STICKER_LOVABLE_STRAIGHT_MUSCLE_IDIOT,STICKER_LOST_TO_MASATO)
	
	--[[If a FIRE "K.E.Y" monster(s) you control would be destroyed, you can send this card from your hand to the GY instead.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.reptg)
	e1:SetValue(s.repval)
	e1:SetOperation(s.repop)
	c:RegisterEffect(e1)
	
	--[[A monster with this Sticker gains the following effects.
	● Other FIRE "K.E.Y" monsters you control gains 800 ATK.
	● "K.E.Y" monsters with 2000 or less ATK cannot be destroyed by battle.
	● "K.E.Y" monsters with 2000 or more ATK cannot be destroyed by card effects.]]
	aux.RegisterStickerEffect(STICKER_LOVABLE_STRAIGHT_MUSCLE_IDIOT,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(s.atktg)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e2:SetTarget(s.prttg1)
		e2:SetValue(1)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(s.prttg2)
		e3:SetValue(1)
		return e1,e2,e3
	end
	)
	
	--[[A card with this Sticker gains the following effect.
	● Once per turn: Your opponent can target 1 monster you control; its ATK/DEF become 0, also negate its effects.]]
	aux.RegisterStickerEffect(STICKER_LOST_TO_MASATO,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetDescription(aux.Stringid(id,6))
		e1:SetCategory(CATEGORIES_ATKDEF|CATEGORY_DISABLE)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_BOTH_SIDE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:OPT()
		e1:SetCondition(aux.oppoact)
		e1:SetTarget(s.distg)
		e1:SetOperation(s.disop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
end

--E1
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end

--S1
function s.atktg(e,c)
	return c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE) and c~=e:GetHandler()
end
function s.prttg1(e,c)
	return c:IsSetCard(ARCHE_KEY) and c:IsAttackBelow(2000)
end
function s.prttg2(e,c)
	return c:IsSetCard(ARCHE_KEY) and c:IsAttackAbove(2000)
end

--S2
function s.disfilter(c)
	return c:IsFaceup() and (not c:IsAttack(0) or not c:IsDefense(0) or aux.NegateMonsterFilter(c))
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetCardOperationInfo(g,CATEGORY_DISABLE)
	Duel.SetCustomOperationInfo(0,CATEGORIES_ATKDEF,g,#g,tp,LOCATION_MZONE,{0})
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToChain() then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
		Duel.Negate(tc,e,0,false,false,TYPE_MONSTER)
	end
end