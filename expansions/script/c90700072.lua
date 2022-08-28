local m=90700072
local cm=_G["c"..m]
cm.name="影中隐匿的少女"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.gop)
	c:RegisterEffect(e2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if not re or re:GetActivateLocation()~=LOCATION_HAND or rp==tp or tc:IsPublic() or not Duel.SelectEffectYesNo(tp,tc) then return end
	local e1=Effect.CreateEffect(tc)
	e1:SetDescription(66)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.rep_op)
	Duel.Readjust()
end
function cm.filter(c,e,tp)
	return c:GetEffectCount(EFFECT_PUBLIC)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rep_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local p=1-tp
	local g=Duel.GetMatchingGroup(cm.filter,p,LOCATION_HAND,0,nil,e,p)
	if Duel.GetLocationCount(p,LOCATION_MZONE)<1 or g:GetCount()<1 or not Duel.SelectYesNo(p,aux.Stringid(m,0)) then return end
	local spc=g:Select(p,1,1,nil):GetFirst()
	Duel.SpecialSummon(spc,0,p,p,false,false,POS_FACEUP)
end
function cm.gop(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsPublic()
end