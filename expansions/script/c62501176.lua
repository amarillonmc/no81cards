--团团圆圆 躲躲团子
function c62501176.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum
	aux.EnablePendulumAttribute(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62501176,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,62501176)
	e1:SetTarget(c62501176.thtg)
	e1:SetOperation(c62501176.thop)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,62501176+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c62501176.sprcon)
	e2:SetOperation(c62501176.sprop)
	e2:SetValue(SUMMON_TYPE_RITUAL)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62501176,0))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,62501176+1)
	e3:SetCondition(c62501176.discon)
	e3:SetTarget(c62501176.distg)
	e3:SetOperation(c62501176.disop)
	c:RegisterEffect(e3)
	--tango remove
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(c62501176.regop)
	c:RegisterEffect(e0)
end
function c62501176.thfilter(c,chk)
	return c:IsSetCard(0xea1) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c62501176.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501176.thfilter,tp,LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c62501176.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c62501176.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if e:GetHandler():IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c62501176.sprfilter(c)
	return (c:IsLevel(1) or c:IsRank(1) or c:IsLink(1)) and c:IsReleasable(REASON_SPSUMMON)
end
function c62501176.gcheck(g,p)
	return Duel.GetLocationCountFromEx(p,p,g,TYPE_SYNCHRO)>0
end
function c62501176.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c62501176.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c62501176.gcheck,3,3,tp)
end
function c62501176.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c62501176.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c62501176.gcheck,false,3,3,tp)
	Duel.Release(sg,REASON_COST)
end
function c62501176.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(Card.IsOnField,1,nil) and Duel.IsChainDisablable(ev)
end
function c62501176.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsOnField,nil)
	if chk==0 then return g:IsExists(Card.IsAbleToGrave,1,nil) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c62501176.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if Duel.NegateEffect(ev) and #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c62501176.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
