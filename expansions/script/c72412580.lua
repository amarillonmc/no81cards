--煌闪之辉光·亨莉雅妲
function c72412580.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WARRIOR),2,3,c72412580.lcheck)
	c:EnableReviveLimit()
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72412580,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e2:SetCountLimit(1,72412580)
	e2:SetCost(c72412580.drcon)
	e2:SetTarget(c72412580.drtg)
	e2:SetOperation(c72412580.drop)
	c:RegisterEffect(e2)
		--target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(c72412580.atlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c72412580.tglimit)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function c72412580.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6727)
end
function c72412580.atlimit(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x6727)
end
function c72412580.tglimit(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x6727)
end
function c72412580.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6727)
end
function c72412580.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c72412580.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c72412580.defilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c72412580.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end
function c72412580.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c72412580.defilter,tp,0,LOCATION_MZONE,1,nil) and c:IsRelateToEffect(e) and c:IsFaceup() then
		--cannot target
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetValue(aux.tgoval)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		--indes
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(aux.indoval)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end