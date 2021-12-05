local m=53703008
local cm=_G["c"..m]
cm.name="圆盘生物 布莱克特琳娜"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllGlobalCheck(c)
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.qcon)
	e1:SetOperation(cm.qop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(cm.ntrtg)
	e5:SetOperation(cm.ntrop)
	c:RegisterEffect(e5)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.qcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetFlagEffect(m)~=0
end
function cm.qop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x153a,1)
	if Duel.DiscardDeck(1-tp,1,REASON_EFFECT)~=0 and #g>0 then
		for tc in aux.Next(g) do
			tc:AddCounter(0x153a,1)
		end
	end
end
function cm.cfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3533) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		Duel.BreakEffect()
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function cm.ntrfilter(c)
	return c:IsFaceup() and c:GetCounter(0x153a)>2 and c:IsControlerCanBeChanged()
end
function cm.ntrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.ntrfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.penfilter(c,tp)
	local rac=Duel.GetFlagEffectLabel(tp,m)
	local b1=nil
	if rac==nil then b1=0 else b1=rac&(c:GetRace())==0 end
	return c:IsSetCard(0x3533) and c:IsType(TYPE_PENDULUM) and b1 and not c:IsForbidden()
end
function cm.ntrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local cg=Duel.SelectMatchingCard(tp,cm.ntrfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if cg:GetCount()>0 and Duel.GetControl(cg:GetFirst(),tp)>0 then
		Duel.BreakEffect()
		if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_DECK,0,1,nil,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
			local tc=g:GetFirst()
			if tc then
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end
