--岭曙龙 奈凯姆-蜿蜒
function c9910815.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910815,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CUSTOM+9910815)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9910815.spcon)
	e1:SetCost(c9910815.spcost)
	e1:SetTarget(c9910815.sptg)
	e1:SetOperation(c9910815.spop)
	c:RegisterEffect(e1)
	--can not be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910815,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910815.cbtcon)
	e2:SetTarget(c9910815.cbttg)
	e2:SetOperation(c9910815.cbtop)
	c:RegisterEffect(e2)
	if not c9910815.global_check then
		c9910815.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c9910815.regcon)
		ge1:SetOperation(c9910815.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9910815.regcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW or Duel.GetCurrentPhase()==0 then return false end
	local v=0
	if eg:IsExists(Card.IsControler,1,nil,0) then v=v+1 end
	if eg:IsExists(Card.IsControler,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c9910815.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+9910815,re,r,rp,ep,e:GetLabel())
end
function c9910815.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==1-tp or ev==PLAYER_ALL
end
function c9910815.dfilter(c,e,tp,lv)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c9910815.spfilter,tp,LOCATION_HAND,0,1,c,e,tp,lv)
end
function c9910815.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9910815.eqfilter,tp,LOCATION_DECK,0,1,nil,tp,lv-c:GetLevel())
end
function c9910815.eqfilter(c,tp,lv)
	return c:IsSetCard(0x6951) and c:IsType(TYPE_MONSTER) and c:IsLevel(lv) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c9910815.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local fe=Duel.IsPlayerAffectedByEffect(tp,9910802)
	local b2=Duel.IsExistingMatchingCard(c9910815.dfilter,tp,LOCATION_HAND,0,1,c,e,tp,lv)
	if chk==0 then return c:IsDiscardable() and c:IsLevelAbove(2) and (fe or b2) end
	if fe and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(9910802,0))) then
		Duel.Hint(HINT_CARD,0,9910802)
		fe:UseCountLimit(tp)
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,c9910815.dfilter,tp,LOCATION_HAND,0,1,1,c,e,tp,lv)
		g:AddCard(c)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
	e:SetLabel(lv)
end
function c9910815.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c9910815.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or lv<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9910815.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lv):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sc=Duel.SelectMatchingCard(tp,c9910815.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp,lv-tc:GetLevel()):GetFirst()
		if not sc then return end
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c9910815.eqlimit)
		sc:RegisterEffect(e1)
	end
end
function c9910815.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c9910815.cbtcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and bit.band(LOCATION_HAND,loc)~=0
end
function c9910815.cbttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9910815)==0 end
end
function c9910815.cbtop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,9910815,RESET_PHASE+PHASE_END,0,1)
end
