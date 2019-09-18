--千早 ～怀念的收获祭～
function c33701067.initial_effect(c)
	 --pendulum summon
	aux.EnablePendulumAttribute(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(33700030)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetDescription(aux.Stringid(33701067,0))
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33701067.destg)
	e1:SetOperation(c33701067.desop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c33701067.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c33701067.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701067,1))
end
function c33701067.desfilter(c)
	return c:IsAbleToHand()
end
function c33701067.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
		and Duel.IsExistingMatchingCard(c33701067.desfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,0)
	Duel.SetChainLimit(c33701067.chlimit)
end
function c33701067.chlimit(e,ep,tp)
	return tp==ep
end
function c33701067.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33701067.desfilter,tp,LOCATION_ONFIELD,0,nil)
	 g:AddCard(e:GetHandler())
	local og=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g*#og==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:Select(tp,1,#og,nil)
	local oc=Duel.SendtoHand(sg,REASON_EFFECT)
	if oc==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg2=og:Select(tp,oc,oc,nil)
	Duel.SendtoHand(sg2,REASON_EFFECT)
end