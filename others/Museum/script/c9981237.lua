--骑士时刻钢斗·高能形态2006
function c9981237.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xbca),3)
	c:EnableReviveLimit()
--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981237,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9981237.rmtg)
	e1:SetOperation(c9981237.rmop)
	c:RegisterEffect(e1)
 --Pos Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c9981237.poscon)
	e3:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e3)
	--must attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e5:SetValue(c9981237.atklimit)
	c:RegisterEffect(e5)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c9981237.distg)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c9981237.atkcon)
	e1:SetValue(2800)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981237.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981237.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981237,0))
end 
function c9981237.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND)
	Duel.SetChainLimit(c9981237.chlimit)
end
function c9981237.chlimit(e,ep,tp)
	return tp==ep
end
function c9981237.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981237,1))
end
function c9981237.poscon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
		and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9981237.atklimit(e,c)
	return c==e:GetHandler()
end
function c9981237.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c9981237.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and not bc:IsType(TYPE_NORMAL)
end