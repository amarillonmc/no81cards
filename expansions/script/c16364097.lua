--影之数码兽 黑战斗暴龙兽·X抗体
function c16364097.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c16364097.atklimit)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e11:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e11)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetCondition(c16364097.discon)
	e2:SetTarget(c16364097.disable)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCountLimit(1,16364097)
	e3:SetTarget(c16364097.destg)
	e3:SetOperation(c16364097.desop)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,16364098)
	e4:SetTarget(c16364097.thtg)
	e4:SetOperation(c16364097.thop)
	c:RegisterEffect(e4)
end
function c16364097.atklimit(e,c)
	return c~=e:GetHandler()
end
function c16364097.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c16364097.disable(e,c)
	return not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
end
function c16364097.desfilter(c,tcseq)
	return (c:IsLocation(LOCATION_MZONE) and (c:GetSequence()==tcseq+1 or c:GetSequence()==tcseq-1))
		or (c:IsLocation(LOCATION_SZONE) and c:GetSequence()==tcseq)
		or (tcseq==1 and c:GetSequence()==5) or (tcseq==3 and c:GetSequence()==6)
end
function c16364097.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	local tcseq=tc:GetSequence()
	local g=Duel.GetMatchingGroup(c16364097.desfilter,tp,0,LOCATION_ONFIELD,nil,tcseq)
	if chk==0 then
		return Duel.GetAttacker()==c and #g>0
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c16364097.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local tcseq=tc:GetSequence()
		local g=Duel.GetMatchingGroup(c16364097.desfilter,tp,0,LOCATION_ONFIELD,nil,tcseq)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c16364097.thfilter(c)
	return c:IsSetCard(0xdc3) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c16364097.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c16364097.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16364097.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end