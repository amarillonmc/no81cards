--刹那芳华 狐御剑
function c10700733.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700733,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCountLimit(1,10700733)
	e1:SetCondition(c10700733.spcon)
	e1:SetTarget(c10700733.sptg)
	e1:SetOperation(c10700733.spop)
	c:RegisterEffect(e1) 
	--scale change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700733,1))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,10700734)
	e2:SetCondition(c10700733.uscon)
	e2:SetTarget(c10700733.ustg)
	e2:SetOperation(c10700733.usop)
	c:RegisterEffect(e2)	
end
function c10700733.spcon(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return h1==h2
end
function c10700733.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10700733.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		  Duel.BreakEffect()
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_FIELD)
		  e1:SetCode(EFFECT_UPDATE_ATTACK)
		  e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		  e1:SetValue(-500)
		  Duel.RegisterEffect(e1,tp)
		  local e2=e1:Clone()
		  e2:SetCode(EFFECT_UPDATE_DEFENSE)
		  Duel.RegisterEffect(e2,tp)
	  end
end
function c10700733.uscon(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return h1>h2
end
function c10700733.ustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c10700733.usop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.DiscardHand(tp,aux.TRUE,1,60,REASON_EFFECT+REASON_DISCARD)
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e1:SetValue(ct)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		c:RegisterEffect(e2)
	end
end