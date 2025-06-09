--太阳的黑之牙 莱纳斯
function c75081048.initial_effect(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetTarget(c75081048.sumtg)
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_BATTLE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,75081048)
	e1:SetCondition(c75081048.condition)
	e1:SetTarget(c75081048.sptg)
	e1:SetOperation(c75081048.spop)
	c:RegisterEffect(e1)
	--atk update
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c75081048.atkval)
	c:RegisterEffect(e2)
	if not c75081048.global_check then
		c75081048.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c75081048.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c75081048.sumtg(e,c)
	return c:IsType(TYPE_MONSTER) and c~=e:GetHandler() and c:IsSetCard(0xa754)
end
--
function c75081048.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0  or bit.band(r,REASON_BATTLE)~=0 then
		Duel.RegisterFlagEffect(ep,75081048,RESET_PHASE+PHASE_END,0,1)
	end
end
function c75081048.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75081048)~=0
end
function c75081048.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa754) and c:IsAbleToHand()
end
function c75081048.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() and Duel.IsExistingMatchingCard(c75081048.thfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c75081048.filter(c)
	return (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)) and c:IsSetCard(0xa754)
end
function c75081048.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75081048.thfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c75081048.filter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75081048,2)) then
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g1=Duel.SelectMatchingCard(tp,c75081048.filter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g1:GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil,1)
			local s2=tc:IsMSetable(true,nil,1)
			if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
			else
				Duel.MSet(tp,tc,true,nil,1)
			end
		end  
	end
end
function c75081048.atkval(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
