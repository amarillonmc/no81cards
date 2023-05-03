--方舟骑士-阿米娅·青色怒火
c29065513.named_with_Arknight=1
function c29065513.initial_effect(c)
	aux.AddCodeList(c,29065500) 
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,29065500,29065508,true,true)
	--change name
	aux.EnableChangeCode(c,29065500)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29065513+EFFECT_COUNT_CODE_DUEL)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetTarget(c29065513.xxtg)
	e1:SetOperation(c29065513.xxop)
	c:RegisterEffect(e1)
end
function c29065513.branded_fusion_check(tp,sg,fc)
	return aux.gffcheck(sg,Card.IsFusionCode,29065500,Card.IsFusionCode,29065508)
end
function c29065513.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackable() and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c29065513.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if c:IsAttackable() and c:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
		local tc=g:GetMinGroup(Card.GetAttack):Select(tp,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c29065513.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		e2:SetOwnerPlayer(tp)
		c:RegisterEffect(e2)
		Duel.CalculateDamage(c,tc)
	end
end
function c29065513.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
