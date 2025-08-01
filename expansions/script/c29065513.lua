--方舟骑士-阿米娅·青色怒火
c29065513.named_with_Arknight=1
function c29065513.initial_effect(c)
	aux.AddCodeList(c,29065500,29065508)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,29065500,29065508,true,true)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065513,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29065513+EFFECT_COUNT_CODE_DUEL)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c29065513.bttg)
	e1:SetOperation(c29065513.btop)
	c:RegisterEffect(e1)
	--boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c29065513.atkval)
	c:RegisterEffect(e2)
end
function c29065513.atkval(e,c)
	if Duel.GetFlagEffect(tp,29065513)==1 then 
		return 1400 
	else
		return 700
	end
end
function c29065513.branded_fusion_check(tp,sg,fc)
	return aux.gffcheck(sg,Card.IsFusionCode,29065500,Card.IsFusionCode,29065508)
end
function c29065513.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackable() and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.GetTurnCount()~=1 end
	Duel.RegisterFlagEffect(tp,29065513,RESET_PHASE+PHASE_END,0,1)
end
function c29065513.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			tc=sg:GetFirst()
		if tc:IsType(TYPE_MONSTER) and tc:IsCanBeBattleTarget(c) and tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE) then
			Duel.CalculateDamage(c,tc)
		end
	end
end
function c29065513.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c29065513.atkcheck(c,atk)
	return c:IsAttackBelow(atk-1)
end
function c29065513.bttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c29065513.atkcheck,tp,0,LOCATION_MZONE,1,nil,atk) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function c29065513.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=c:GetAttack()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c29065513.atkcheck,tp,0,LOCATION_MZONE,1,1,nil,atk)
		if dg:GetCount()>0 then
			Duel.HintSelection(dg)
			local tc=dg:GetFirst()
			local minatk=tc:GetAttack()
			local dam=atk-minatk
			if Duel.Destroy(dg,REASON_EFFECT)>0 then
				Duel.Damage(1-tp,dam,REASON_EFFECT)
			end
		end
	end
end