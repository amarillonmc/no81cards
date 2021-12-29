local m=15000923
local cm=_G["c"..m]
cm.name="死蔷薇的证词-『饮蛇』"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000937)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.splimcon)
	e1:SetTarget(cm.splimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e2)
	cm.deadrose_effect_onfield_splimit=e1
	cm.deadrose_effect_onfield_slimit=e2
	--change effect type
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(15000923)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	cm.deadrose_effect_onfield=e3
	--synchro!
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,15000923)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
	cm.deadrose_effect_three=e4
end
function cm.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function cm.splimit(e,c)
	return c:IsSetCard(0x3f3f)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PLANT) and c:IsAbleToGrave()
end
function cm.tg3filter(c)
	return c:IsCode(15000937) and c:IsAbleToGrave()
end
function cm.fselect(g)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	return g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and tc1:GetLevel()+tc2:GetLevel()==8
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tg3filter,tp,LOCATION_EXTRA,0,1,nil) and g:CheckSubGroup(cm.fselect,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:SelectSubGroup(tp,cm.fselect,false,2,2)
	if g1 and g1:GetCount()==2 and Duel.SendtoGrave(g1,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g3=Duel.SelectMatchingCard(tp,cm.tg3filter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g3:GetCount()~=0 then
			Duel.SendtoGrave(g3,REASON_EFFECT)
		end
	end
end