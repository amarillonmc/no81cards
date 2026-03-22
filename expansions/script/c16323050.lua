--王·擎天之光
function c16323050.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16323050)
	e1:SetTarget(c16323050.target)
	e1:SetOperation(c16323050.operation)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16323050)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c16323050.sptg)
	e2:SetOperation(c16323050.spop)
	c:RegisterEffect(e2)
end
function c16323050.getrg(tp,chk)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_EFFECT)
	local mrg=rg:Filter(Card.IsHasEffect,nil,EFFECT_EXTRA_RELEASE)
	if mrg:GetCount()>0 then
		return mrg:Filter(c16323050.cfilter,nil,tp,chk)
	else
		return rg:Filter(c16323050.cfilter,nil,tp,chk)
	end
end
function c16323050.cfilter(c,tp,chk)
	return c:IsRace(RACE_MACHINE) and c:IsReleasableByEffect()
	and (not chk or Duel.GetMZoneCount(tp,c)>0)
end
function c16323050.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x3dcf)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16323050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=c16323050.getrg(tp,true)
	if chk==0 then return rg:GetCount()>0 
		and Duel.IsExistingMatchingCard(c16323050.spfilter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c16323050.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local srg=c16323050.getrg(tp,true)
	if srg:GetCount()==0 then
		srg=c16323050.getrg(tp,false)
	end
	local rg=srg:Select(tp,1,1,nil)
	if rg:GetCount()>0 and Duel.Release(rg,REASON_EFFECT)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16323050.spfilter),tp,0x13,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c16323050.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c16323050.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		--damage
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(16323050,0))
		e2:SetCategory(CATEGORY_DAMAGE)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_BATTLE_CONFIRM)
		e2:SetCondition(c16323050.damcon)
		e2:SetTarget(c16323050.damtg)
		e2:SetOperation(c16323050.damop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c16323050.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsControler(1-tp) and bc:GetBaseAttack()>0
end
function c16323050.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetBattleTarget():GetBaseAttack()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.ceil(atk/2))
end
function c16323050.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsFaceup() and tc:IsControler(1-tp) and tc:IsRelateToBattle() then
		local atk=tc:GetBaseAttack()
		Duel.Damage(1-tp,math.ceil(atk/2),REASON_EFFECT)
	end
end