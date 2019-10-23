--疫魔扩张
function c40008643.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40008643+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1) 
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008643,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c40008643.condition)
	e2:SetTarget(c40008643.sptg)
	e2:SetOperation(c40008643.spop)
	c:RegisterEffect(e2) 
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetTargetRange(1,0)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c40008643.splimit)
	c:RegisterEffect(e3) 
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40008643,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,40008643)
	e4:SetCost(c40008643.cost)
	e4:SetTarget(c40008643.target)
	e4:SetOperation(c40008643.activate)
	c:RegisterEffect(e4)  
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40008643,2))
	e5:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c40008643.thcon)
	e5:SetTarget(c40008643.destg)
	e5:SetOperation(c40008643.desop)
	c:RegisterEffect(e5)
end
c40008643.card_code_list={40008641}
function c40008643.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function c40008643.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,40008644,0,0x4011,300,300,1,RACE_MACHINE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c40008643.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,40008644,0,0x4011,300,300,1,RACE_MACHINE,ATTRIBUTE_DARK) then
		local token1=Duel.CreateToken(tp,40008644)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
function c40008643.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_HAND) and not c:IsCode(40008641)
end
function c40008643.rfilter(c,e,tp)
	return c:IsRace(RACE_FIEND)
		and Duel.IsExistingTarget(c40008643.spfilter1,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c40008643.spfilter1(c,code,e,tp)
	return c:IsRace(RACE_FIEND) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008643.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c40008643.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c40008643.spfilter1(chkc,e:GetLabel(),e,tp) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c40008643.rfilter,1,nil,e,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,c40008643.rfilter,1,1,nil,e,tp)
	local code=g:GetFirst():GetCode()
	e:SetLabel(code)
	Duel.Release(g,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c40008643.spfilter1,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function c40008643.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c40008643.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and rp==1-tp and c:IsReason(REASON_DESTROY)
end
function c40008643.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c40008643.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
	   if Duel.Destroy(tc,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,300,REASON_EFFECT)
		end
	end
end

