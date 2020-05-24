--德克萨斯
function c9910438.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910438)
	e1:SetCondition(c9910438.drcon)
	e1:SetTarget(c9910438.drtg)
	e1:SetOperation(c9910438.drop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910439)
	e2:SetTarget(c9910438.desreptg)
	e2:SetValue(c9910438.desrepval)
	e2:SetOperation(c9910438.desrepop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9910438.sumsuc)
	c:RegisterEffect(e8)
end
function c9910438.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9910438,0))
end
function c9910438.cfilter(c,lg)
	return lg:IsContains(c)
end
function c9910438.drcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c9910438.cfilter,1,nil,lg)
end
function c9910438.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910438.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9910438.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLinkState() and c:IsReason(REASON_BATTLE)
end
function c9910438.repfilter2(c,e)
	return not c:IsStatus(STATUS_DESTROY_CONFIRMED) and not c:IsImmuneToEffect(e)
end
function c9910438.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c9910438.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c9910438.repfilter2,tp,0,LOCATION_ONFIELD,1,nil,e) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c9910438.desrepval(e,c)
	return c9910438.repfilter(c,e:GetHandlerPlayer())
end
function c9910438.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910438.repfilter2,tp,0,LOCATION_ONFIELD,1,1,nil,e)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9910438,1))
end
