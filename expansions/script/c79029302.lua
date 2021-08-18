--末药·生命之地收藏-辛味
function c79029302.initial_effect(c)
	--link summon
	aux.EnablePendulumAttribute(c)
	aux.AddLinkProcedure(c,c79029302.mfilter,2,2)
	c:EnableReviveLimit()
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029128)
	c:RegisterEffect(e2)   
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,79029302)
	e4:SetTarget(c79029302.pentg)
	e4:SetOperation(c79029302.penop)
	c:RegisterEffect(e4)	
	--ex p
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c79029302.expcost)
	e3:SetOperation(c79029302.expop)
	c:RegisterEffect(e3)
end
c79029302.pendulum_level=2 
function c79029302.mfilter(c)
	return c:IsLinkSetCard(0xa900) and c:IsLinkType(TYPE_PENDULUM)
end
function c79029302.tefil(c)
	return c:IsSetCard(0xa900) and c:IsAbleToExtra() and c:IsType(TYPE_PENDULUM)
end
function c79029302.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c79029302.tefil,tp,LOCATION_DECK,0,1,nil) end
	Debug.Message("唔唔，手忙脚乱的......没犯大错真是太好了......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029302,1))
	local g=Duel.SelectMatchingCard(tp,c79029302.tefil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,tp,LOCATION_DECK)
end
function c79029302.penop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not Duel.SendtoExtraP(tc,tp,REASON_EFFECT) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(tc:GetLeftScale())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(tc:GetRightScale())
		c:RegisterEffect(e2)
	end
end
function c79029302.expcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c79029302.expop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029302,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCountLimit(1,79029302)
	e2:SetValue(c79029302.pendvalue)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Debug.Message("有没有需要治疗的人呢？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029302,2))
end
function c79029302.pendvalue(e,c)
	return c:IsSetCard(0xa900)
end










