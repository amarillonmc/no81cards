--影之数码兽 黑战斗暴龙兽
function c16364095.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c16364095.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c16364095.atklimit)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c16364095.discon)
	e2:SetTarget(c16364095.disable)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCountLimit(1,16364095)
	e3:SetTarget(c16364095.destg)
	e3:SetOperation(c16364095.desop)
	c:RegisterEffect(e3)
end
function c16364095.matfilter1(c,syncard)
	return c:IsSetCard(0xcb1,0xdc3) and (c:IsTuner(syncard) or c:IsLevelBelow(4))
end
function c16364095.atklimit(e,c)
	return c~=e:GetHandler()
end
function c16364095.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c16364095.disable(e,c)
	return c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0
end
function c16364095.desfilter(c,tcseq)
	return (c:IsLocation(LOCATION_MZONE) and (c:GetSequence()==tcseq+1 or c:GetSequence()==tcseq-1))
		or (c:IsLocation(LOCATION_SZONE) and c:GetSequence()==tcseq)
		or (tcseq==1 and c:GetSequence()==5) or (tcseq==3 and c:GetSequence()==6)
end
function c16364095.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	local tcseq=tc:GetSequence()
	local g=Duel.GetMatchingGroup(c16364095.desfilter,tp,0,LOCATION_MZONE,nil,tcseq)
	if chk==0 then
		return Duel.GetAttacker()==c and #g>0
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c16364095.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local tcseq=tc:GetSequence()
		local g=Duel.GetMatchingGroup(c16364095.desfilter,tp,0,LOCATION_MZONE,nil,tcseq)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end