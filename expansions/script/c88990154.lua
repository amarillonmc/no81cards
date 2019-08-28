--カオス・フォーム
function c88990154.initial_effect(c)
	aux.AddRitualProcEqual2(c,c88990154.filter,nil,c88990154.mfilter)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88990154,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,88990154)
	e2:SetCondition(c88990154.setcon)
	e2:SetTarget(c88990154.settg)
	e2:SetOperation(c88990154.setop)
	c:RegisterEffect(e2)
end

function c88990154.filter(c,e,tp,m1,m2,ft)
	return c:IsSetCard(0x3a)
end
function c88990154.mfilter(c)
	return c:IsSetCard(0x3a)
end
function c88990154.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c88990154.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
end
function c88990154.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end

