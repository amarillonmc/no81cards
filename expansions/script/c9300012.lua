--防卫之遮名者
function c9300012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9300012.target)
	e1:SetOperation(c9300012.activate)
	c:RegisterEffect(e1)
end
function c9300012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c9300012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	--CANNOT_DISABLE_SUMMON/
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(c9300012.etarget)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetLabel(ac)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	Duel.RegisterEffect(e3,tp)
	--cannot inactivate/disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetValue(c9300012.efilter1)
	e4:SetLabel(ac)
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e5,tp)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e6:SetTarget(c9300012.etarget)
	e6:SetValue(c9300012.efilter2)
	e6:SetLabel(ac)
	e6:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e6,tp)
end
function c9300012.etarget(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function c9300012.efilter1(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:IsOriginalCodeRule(e:GetLabel())
end
function c9300012.efilter2(e,re)
	return not re:GetHandler():IsOriginalCodeRule(e:GetLabel())
end