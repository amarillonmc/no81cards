--晶机艺•过客
local m=20000419
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000400") end) then require("script/c20000400") end
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfd4),aux.NonTuner(nil),1)
	aux.AddCodeList(c,20000400)
	c:EnableReviveLimit()
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.sumcon)
	e1:SetTarget(cm.sumtg)
	e1:SetOperation(cm.sumop)
	c:RegisterEffect(e1)
	--immue
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.imv)
	c:RegisterEffect(e2)
end
--e1
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.sumopf(c,e,tp)
	return c:IsSetCard(0xfd4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
		local sc=Duel.SelectMatchingCard(tp,cm.sumopf,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.efilter1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(fu_hd.GiveTarget)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.efilter1(e,te)
	return te:IsActivated()
end
--e2
function cm.imv(e,te)
	return te:GetOwner()~=e:GetOwner()
end