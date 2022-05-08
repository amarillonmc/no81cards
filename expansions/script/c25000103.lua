local m=25000103
local cm=_G["c"..m]
cm.name="身后事"
cm.Snnm_Ef_Rst=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TOKEN)
end
function cm.spfilter(c,e,tp)
	local p=c:GetControler()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(p,tp,nil,c)) or (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(p)>0))
end
function cm.spfilter2(c,e,tp)
	return cm.spfilter(c,e,tp) and c:IsRelateToEffect(e)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.spfilter,nil,e,tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local dg=eg:Filter(cm.spfilter2,nil,e,tp)
	if #dg==0 then return end
	local sg=dg:Clone()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if #dg>1 then sg=dg:Select(tp,1,1,nil) end
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(function(c)return c:IsFaceup() and c:IsType(TYPE_EFFECT)end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetOperation(cm.op)
		tc:RegisterEffect(e1)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsType(TYPE_MONSTER) then return end
	Duel.RegisterFlagEffect(0,m+e:GetHandler():GetOriginalCodeRule(),0,0,0)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetLabel(e:GetHandler():GetOriginalCodeRule())
	e2:SetOperation(cm.negop)
	Duel.RegisterEffect(e2,tp)
	e:Reset()
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsLocation(LOCATION_MZONE) or re:GetHandler():GetCode()~=e:GetLabel() then return end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,aux.NULL)
end
