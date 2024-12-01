--极简塔防 武装金矿
function c65850055.initial_effect(c)
	c:SetSPSummonOnce(65850055)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c65850055.matfilter,1,1)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetTarget(c65850055.desreptg)
	e1:SetValue(c65850055.desrepval)
	e1:SetOperation(c65850055.desrepop)
	c:RegisterEffect(e1)
	--link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65850055,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65850055+1)
	e2:SetCondition(c65850055.lkcon)
	e2:SetTarget(c65850055.lktg)
	e2:SetOperation(c65850055.lkop)
	c:RegisterEffect(e2)
end


function c65850055.matfilter(c)
	return c:IsLinkSetCard(0xa35) and not c:IsCode(65850055)
end

function c65850055.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c65850055.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c65850055.repfilter,1,nil,tp)
		and c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(65850055,0))
end
function c65850055.desrepval(e,c)
	return c65850055.repfilter(c,e:GetHandlerPlayer())
end
function c65850055.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65850055)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
function c65850055.splimit(e,c)
	return not c:IsSetCard(0xa35)
end

function c65850055.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c65850055.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65850055.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65850055.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c65850055.lkfilter,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
function c65850055.lkfilter(c,lc)
	return c:IsSetCard(0xa35) and c:IsLinkSummonable(nil,lc)
end