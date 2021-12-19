--无尽传说的续章
--21.04.13
local m=11451410
local cm=_G["c"..m]
cm.IsFusionSpellTrap=true
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA+LOCATION_SZONE)
	e1:SetLabelObject(e0)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCost(cm.costchk)
	e2:SetTarget(cm.actarget)
	e2:SetOperation(cm.costop)
	c:RegisterEffect(e2)
	--type
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_REMOVE_TYPE)
	e5:SetRange(0xff)
	e5:SetValue(TYPE_FUSION)
	c:RegisterEffect(e5)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if #g>0 then e:SetLabel(g:GetClassCount(Card.GetCode)) end
end
function cm.filter(c)
	return (_G["c"..c:GetOriginalCode()] and _G["c"..c:GetOriginalCode()].traveler_saga) and c:IsAbleToDeckAsCost()
end
function cm.costchk(e,te,tp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,3,nil)
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,3,3,nil)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-c:GetControler(),cg) end
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(11451406) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b2 end
	local num=e:GetLabelObject():GetLabel()
	local op=0
	if b1 then
		if num==3 then
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		end
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,op))
	if op~=1 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_DECK) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():SetStatus(STATUS_EFFECT_ENABLED,true)
	local op=e:GetLabel()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if op~=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 then
		local tg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
			Duel.MoveSequence(tc,1)
		end
	end
end