--黑钢国际·近卫干员-芙兰卡
function c79029044.initial_effect(c)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029044.spcon)
	e1:SetTarget(c79029044.sptg)
	e1:SetCountLimit(1,79029044)
	e1:SetOperation(c79029044.spop)
	c:RegisterEffect(e1)  
	--repeat attack
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1)
	e2:SetTarget(c79029044.thtg)
	e2:SetOperation(c79029044.thop)
	c:RegisterEffect(e2)
end
function c79029044.sprfilter(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsSetCard(0x1904) and bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:IsAbleToGraveAsCost()
end
function c79029044.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function c79029044.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029044.sprfilter,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c79029044.fselect,2,2,tp)
end
function c79029044.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c79029044.sprfilter,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c79029044.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c79029044.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function c79029044.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c79029044.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) and c:IsChainAttackable() then
		Duel.ChainAttack()
	end
end
