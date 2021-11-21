--SCP基金会 Dr.Clef
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m,cm=rscf.DefineCard(16102013,"SCP_J")
function cm.initial_effect(c)
		aux.AddLinkProcedure(c,cm.lkfilter,4,4)
		c:EnableReviveLimit()
		c:SetUniqueOnField(1,1,m)
	local e1=rsef.SV_INDESTRUCTABLE(c,"effect")
	local e2=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.spfilter,"sp",LOCATION_DECK),cm.spop)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+100)
	e3:SetCondition(cm.chcon)
	e3:SetTarget(cm.chtg)
	e3:SetOperation(cm.chop)
	c:RegisterEffect(e3)
end
function cm.lkfilter(c)
	return c:CheckSetCard("SCP")
end
function cm.spfilter(c,e,tp)
	return c:IsCode(16102002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsType(TYPE_MONSTER)
end
function cm.spop(e,tp)
	if not Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	tc=g:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp or ep~=tp
end
function cm.filter(c)
	return c:IsReleasable()
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,re:GetHandler():GetControler(),LOCATION_ONFIELD+LOCATION_HAND,0,1,re:GetHandler()) end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
--
function cm.repop(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	if g:GetCount()>0 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		  sg=g:Select(tp,1,1,e:GetHandler())
		  Duel.Release(sg,REASON_EFFECT)
		end
end