--自然色彩 苍绿熙叶
Duel.LoadScript("c33502100.lua")
local m=33502103
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e9=Suyuz.tograve(c,CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE,m,cm.op)
	--HZ
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Suyuz.gaincon(m))
	e3:SetTarget(cm.target)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(cm.descon)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	if not BZo_p then
		BZo_p={}
		BZo_p["Effects"]={}
	end
	BZo_p["Effects"]["c33502103"]=cm.disop
end
--e1
function cm.op(e,tp)
	local c=e:GetHandler()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.disop)
	e1:SetLabel(e)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabel()
	if te==re or not (re:IsActiveType(TYPE_MONSTER) and re:IsActivated()) then return end
	local tep=re:GetHandlerPlayer()
	if not (Duel.IsExistingMatchingCard(cm.splimit0,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,e,tp) and Duel.IsExistingMatchingCard(cm.splimit1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp))  then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,cm.splimit0,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
		if Duel.Release(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local dg=Duel.SelectMatchingCard(tp,cm.splimit1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
			if dg:GetCount()>0 then
				Duel.SpecialSummon(dg,0,tp,tp,false,false,POS_FACEUP)
				local tcg=Duel.GetOperatedGroup()
				local sc=tcg:GetFirst()
				while sc do
				local mcode=sc:GetOriginalCode()
				if sc:IsSetCard(0x2a80) then
				sc:RegisterFlagEffect(mcode+100,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33502100,0))
				end
				sc=tcg:GetNext()
				end
			end
		end
	end
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_PLANT)
end
function cm.splimit0(c)
	return c:IsRace(RACE_PLANT) and c:IsReleasable()
end
function cm.splimit1(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--e4
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--immune (FAQ in Card Target)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.target)
	e2:SetValue(cm.efilter)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.target(e,c)
	local g,te=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_EFFECT)
	return not (te and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET))
		or not (g and g:IsContains(c))
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end