local m=15006194
local cm=_G["c"..m]
cm.name="巡星兽 苍白腐化"
function cm.initial_effect(c)
	aux.AddCodeList(c,15006200)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9f44),aux.FilterBoolFunction(Card.IsRace,RACE_ILLUSION),true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--
	aux.RegisterMergedDelayedEvent(c,m,EVENT_SPSUMMON_SUCCESS)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,5))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetCondition(cm.con3)
	c:RegisterEffect(e3)
end
function cm.cgcheck(g,tp)
	local b1=g:IsExists(cm.ritfilter,1,nil,tp) and not Duel.IsPlayerAffectedByEffect(tp,15006194)
	local b2=g:IsExists(cm.fusfilter,1,nil,tp) and not Duel.IsPlayerAffectedByEffect(tp,15006195)
	local b3=g:IsExists(cm.excfilter,1,nil,tp) and not Duel.IsPlayerAffectedByEffect(tp,15006196)
	local res=0
	if b1 then res=res+1 end
	if b2 then res=res+1 end
	if b3 then res=res+1 end
	return res
end
function cm.cfilter(c,e,tp)
	local b1=cm.ritfilter(c,tp) and not Duel.IsPlayerAffectedByEffect(tp,15006194)
	local b2=cm.fusfilter(c,tp) and not Duel.IsPlayerAffectedByEffect(tp,15006195)
	local b3=cm.excfilter(c,tp) and not Duel.IsPlayerAffectedByEffect(tp,15006196)
	return c:IsFaceup() and c:IsSetCard(0x9f44) and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e) and (b1 or b2 or b3)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,e,tp) and cm.cgcheck(eg,tp)>=1
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,e,tp) and cm.cgcheck(eg,tp)>=2
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,e,tp) and cm.cgcheck(eg,tp)>=3
end
function cm.ritfilter(c,tp)
	return c:IsType(TYPE_RITUAL) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.thfilter(c,code)
	return c:IsSetCard(0x9f44) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(code)
end
function cm.fusfilter(c,tp)
	return c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
end
function cm.excfilter(c,tp)
	return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(cm.drafilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and (not (c:IsType(TYPE_RITUAL) or c:IsType(TYPE_FUSION)))
end
function cm.drafilter(c)
	return c:IsCode(15006200) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ag=eg:Filter(cm.cfilter,nil,e,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.cfilter(chkc,e,tp) end
	if chk==0 then return #ag>0 end
	local sg=Group.CreateGroup()
	if ag:GetCount()==1 then
		sg=ag:Clone()
		Duel.SetTargetCard(sg)
	else
		Duel.Hint(HINTMSG_DESTROY,tp,HINTMSG_TARGET)
		sg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_MZONE,0,1,1,nil,ag)
	end
	local tc=sg:GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	if tc:IsType(TYPE_RITUAL) then e1:SetCode(15006194)
	elseif tc:IsType(TYPE_FUSION) then e1:SetCode(15006195)
	else e1:SetCode(15006196) end
	e1:SetTargetRange(1,0)
	if tc:IsType(TYPE_RITUAL) then e1:SetDescription(aux.Stringid(m,0))
	elseif tc:IsType(TYPE_FUSION) then e1:SetDescription(aux.Stringid(m,1))
	else e1:SetDescription(aux.Stringid(m,2)) end
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if tc:IsType(TYPE_RITUAL) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif tc:IsType(TYPE_FUSION) then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetLabel(2)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	else
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
		e:SetLabel(3)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local l=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if l==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			if tc:IsAbleToGrave() and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
				Duel.BreakEffect()
				if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
					Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	elseif l==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif l==3 then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.drafilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end