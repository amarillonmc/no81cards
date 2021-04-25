--无尽传说的续章
--21.04.13
local m=11451410
local cm=_G["c"..m]
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
	e1:SetRange(LOCATION_EXTRA)
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
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if #g>0 then e:SetLabel(g:GetClassCount(Card.GetCode)) end
end
function cm.filter(c)
	return _G["c"..c:GetOriginalCode()].traveler_saga and c:IsAbleToDeckAsCost()
end
function cm.costchk(e,te,tp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,3,nil)
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,3,3,nil)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-c:GetControler(),cg) end
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,11451406,0,0x21,0,0,1,RACE_WARRIOR,ATTRIBUTE_LIGHT)
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local num=e:GetLabelObject():GetLabel()
	local op=0
	if b1 and b2 then
		if num==3 then
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	if op~=1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	if op~=1 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,11451406,0,0x21,0,0,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		c:SetEntityCode(11451406,true)
		c:ReplaceEffect(11451406,0)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
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