--特莱恩之落穴
function c98920296.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c98920296.con)
	e0:SetTarget(c98920296.target)
	e0:SetOperation(c98920296.activate)
	c:RegisterEffect(e0)
	--SSet
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920296,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,98920296)
	e1:SetCondition(c98920296.spcon)
	e1:SetTarget(c98920296.sptg)
	e1:SetOperation(c98920296.spop)
	c:RegisterEffect(e1)
end
function c98920296.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and Duel.IsExistingMatchingCard(c98920296.sfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98920296.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x108a)
end
function c98920296.filter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsSummonLocation(LOCATION_EXTRA)
		and c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsLocation(LOCATION_MZONE)
end
function c98920296.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return c98920296.filter(tc,tp,ep) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c98920296.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then 
		 Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)	  
		 local atk=tc:GetBaseAttack()   
		 local mg=Duel.GetMatchingGroup(c98920296.sfilter,tp,LOCATION_MZONE,0,nil) 
		 local tc1=mg:GetFirst()
		 while tc1 do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc1:RegisterEffect(e1,true)
			tc1=mg:GetNext()
		end
	end
end
function c98920296.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c98920296.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c98920296.cfilter(c)
	return c:IsFaceup() and c:IsCode(91812341)
end
function c98920296.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c98920296.cfilter,tp,LOCATION_MZONE,0,1,nil) and c:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(98920296,1)) then
		 Duel.BreakEffect()
		 Duel.SSet(tp,c)
	end
end