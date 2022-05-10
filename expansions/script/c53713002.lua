local m=53713002
local cm=_G["c"..m]
cm.name="ALC之眼 JGN"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c)return c:GetOriginalType()&TYPE_TRAP~=0 and c:IsFusionType(TYPE_MONSTER)end,2,true)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(2,m)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return eg:IsExists(Card.IsControler,1,nil,1-tp)end)
	e2:SetTarget(cm.alctg1)
	e2:SetOperation(cm.alcop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOEXTRA)
	e4:SetTarget(cm.alctg2)
	e4:SetOperation(cm.alcop2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(cm.con)
	e6:SetOperation(cm.op)
	c:RegisterEffect(e6)
end
function cm.filter(c,tp)
	return aux.NegateMonsterFilter(c) and c:IsControler(1-tp) and Duel.IsExistingMatchingCard(cm.setfilter1,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function cm.setfilter1(c,code)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsCode(code)
end
function cm.tefilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
end
function cm.setfilter2(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:GetType()&0x20004==0x20004
end
function cm.alctg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(cm.filter,1,nil,tp) and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0 end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(cm.filter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.alctg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_ONFIELD)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.alcop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,cm.setfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tc:GetCode())
	local sc=sg:GetFirst()
	if not sc then return end
	Duel.HintSelection(Group.FromCards(sc,tc))
	sc:CancelToGrave()
	local pos=Duel.ChangePosition(sc,POS_FACEDOWN)
	if pos==0 then return end
	if sc:IsType(TYPE_SPELL+TYPE_TRAP) then Duel.RaiseEvent(sc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) end
	if tc:IsDisabled() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	Duel.AdjustInstantly()
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if #hg==0 then return end
	local gg=hg:RandomSelect(1-tp,1)
	Duel.SendtoGrave(Group.__add(tc,gg),REASON_EFFECT)
end
function cm.alcop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g==0 then return end
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_EXTRA) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,cm.setfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if #sg==0 then return end
	Duel.HintSelection(sg)
	local rg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		tc:CancelToGrave()
		if Duel.ChangePosition(tc,POS_FACEDOWN)~=0 and tc:IsFacedown() then rg:AddCard(tc) end
	end
	Duel.RaiseEvent(rg,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FUSION))
	e1:SetValue(cm.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
