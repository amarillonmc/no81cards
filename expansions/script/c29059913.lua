--源石秘术·重力
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.NegateSummonCondition() and eg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.cfilter(c)
	return c:IsFaceupEx() and c:IsRace(RACE_SPELLCASTER) and (c:IsSetCard(0x87af) or (_G["c"..c:GetOriginalCode()] and _G["c"..c:GetOriginalCode()].named_with_Arknight))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.tdtg)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	Duel.RegisterEffect(e2,tp)
end
function cm.tdtg(e,c)
	return c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsType,1,REASON_EFFECT,false,nil,TYPE_TOKEN) and e:GetHandler():IsAbleToHand() and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.SelectReleaseGroupEx(tp,Card.IsType,1,1,REASON_EFFECT,false,nil,TYPE_TOKEN)
	if Duel.Release(rg,REASON_EFFECT)>0 then
		if c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		end
	end
end