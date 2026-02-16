--霜华神社
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Synchro summon   
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,id)
	e2:SetCondition(Auxiliary.SynMixCondition(aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,s.syncheck))
	e2:SetTarget(Auxiliary.SynMixTarget(aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,s.syncheck))
	e2:SetOperation(s.SynMixOperation)
	e2:SetValue(SUMMON_TYPE_SYNCHRO) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(s.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6a70)
		and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.syncheck(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x6a70)
end
function s.SynMixOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function s.mattg(e,c)
	if not c:IsType(TYPE_SYNCHRO) then return false end
	local tab={14000248,14010109,33730071,79029117,90700065,90700066,90700067,90700068,90700069,92361302,92361306,98731001}
	for _,code in pairs(tab) do
		if c:GetOriginalCode()==code then return false end
	end
	local eset={c:IsHasEffect(EFFECT_SPSUMMON_CONDITION)}
	for _,te in pairs(eset) do
		if te:GetOwner()==c and (te:GetValue()==0 or te:GetValue()==aux.FALSE) then return false end
	end
	return true
end