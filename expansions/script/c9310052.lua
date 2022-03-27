--波动武士·单调防御场
function c9310052.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3f91),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9310052.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9310052.sprcon)
	e2:SetTarget(c9310052.sprtg)
	e2:SetOperation(c9310052.sprop)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(c9310052.tnval)
	c:RegisterEffect(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c9310052.efilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c9310052.effectfilter)
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9310052,0))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCountLimit(1)
	e6:SetCondition(c9310052.rmcon)
	e6:SetTarget(c9310052.rmtg)
	e6:SetOperation(c9310052.rmop)
	c:RegisterEffect(e6)
end
c9310052.material_setcode=0x3f91
function c9310052.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or
			   ((not se or not se:IsHasType(EFFECT_TYPE_ACTIONS)) and aux.synlimit)
end
function c9310052.mzfilter(c)
	return c:IsAbleToGraveAsCost() and (c:GetLevel()>=1)
end
function c9310052.fselect(g,lv,c)
	local tp=c:GetControler()
	return g:GetSum(Card.GetLevel)==lv and g:GetCount()>=2 and g:IsExists(Card.IsRace,1,nil,RACE_PSYCHO) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function c9310052.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9310052.mzfilter,tp,LOCATION_MZONE,0,nil)
	local lv=8
	while lv<=g:GetSum(Card.GetLevel) do
		local res=g:CheckSubGroup(c9310052.fselect,2,#g,lv,c)
		if res then return true end
		lv=lv+8
	end
	return false
end
function c9310052.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c9310052.mzfilter,tp,LOCATION_MZONE,0,nil)
	local tp=c:GetControler()
	local list={}
	local lv=8
	while lv<=g:GetSum(Card.GetLevel) do
		if g:CheckSubGroup(c9310052.fselect,2,#g,lv,c) then table.insert(list,lv) end
		lv=lv+8
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9310052,0))
	local clv=Duel.AnnounceNumber(tp,table.unpack(list))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c9310052.fselect,Duel.IsSummonCancelable(),2,#g,clv,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c9310052.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Card.SetMaterial(c,sg)
	Duel.SendtoGrave(sg,REASON_COST+REASON_MATERIAL)
end
function c9310052.tnval(e,c)
	return e:GetHandler():IsDefensePos()
end
function c9310052.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsType(TYPE_SYNCHRO)
end
function c9310052.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsType(TYPE_SYNCHRO)
		   and te:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)   
end
function c9310052.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLevel(4)
end
function c9310052.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9310052.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		if c:IsLevel(4) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end