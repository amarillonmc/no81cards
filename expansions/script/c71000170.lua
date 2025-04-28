function c71000170.initial_effect(c)
	c:SetSPSummonOnce(71000170)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c71000170.mfilter,1,1)
	 --效果②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71000170,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,71000170)
	e2:SetCondition(c71000170.drcon)
	e2:SetTarget(c71000170.drtg)
	e2:SetOperation(c71000170.drop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c71000170.splimit)
	c:RegisterEffect(e4)
end
function c71000170.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_SPELLCASTER)
end

	--get effect

--===== 效果①处理 =====--
function c71000170.mfilter(c)
	return c:IsLinkSetCard(0xe73)
end
--===== 效果②处理 =====--
function c71000170.drcon(e,tp,eg,ep,ev,re,r,rp)
	return  r==REASON_LINK
end
function c71000170.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c71000170.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
