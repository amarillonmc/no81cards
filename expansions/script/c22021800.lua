--人理之基 宫本伊织
function c22021800.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c22021800.mfilter,c22021800.xyzcheck,2,63)
	--attack twice
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetCondition(c22021800.con1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk,def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetCondition(c22021800.con2)
	e2:SetValue(2500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetCondition(c22021800.con3)
	c:RegisterEffect(e4)
	--disable and atk down
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(0)
	e5:SetCondition(c22021800.con4)
	e5:SetTarget(c22021800.adtg)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e5:SetValue(0)
	e6:RegisterEffect(e6)
	--disable and atk down
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_DISABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetCondition(c22021800.adcon)
	e7:SetTarget(c22021800.adtg)
	c:RegisterEffect(e7)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e9)
end
function c22021800.mfilter(c,xyzc)
	return c:IsSetCard(0xff1)
end
function c22021800.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c22021800.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND) or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,22021770)
end
function c22021800.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH) or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,22021770)
end
function c22021800.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE) or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,22021770)
end
function c22021800.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:GetBattleTarget()
		and (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL) and (e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,22021770))
end
function c22021800.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TURE,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TURE,tp,0,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c22021800.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(tg,REASON_EFFECT)
end
function c22021800.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:GetBattleTarget()
		and (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL) and (e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,22021770))
end
function c22021800.adtg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end