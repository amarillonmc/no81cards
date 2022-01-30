local m=53728007
local cm=_G["c"..m]
cm.name="巨征啼鸟 天卫三"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(function(e,c,og,min,max)
				if c==nil then return true end
				local tp=c:GetControler()
				return Duel.CheckXyzMaterial(c,cm.xyzfilter,4,2,2,Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0))
			end)
	e0:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then return true end
				local g=Duel.SelectXyzMaterial(tp,c,cm.xyzfilter,4,2,2,Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0))
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				local sg=Group.CreateGroup()
				if og and not min then
					for tc in aux.Next(og) do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					for tc in aux.Next(mg) do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(function(e,c,rc)if rc==e:GetHandler() then return c:GetOriginalLevel() else return c:GetLevel()end end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.eqcost)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_EQUIP)
	e3:SetCountLimit(1,m+50)
	e3:SetCondition(cm.tgcon)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
function cm.xyzfilter(c)
	return c:IsFaceup() and c:IsOriginalSetCard(0xc532)
end
function cm.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,c,tp)
end
function cm.eqfilter(c,ec,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_UNION) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,tc,tc,tp):GetFirst()
		if ec and Duel.Equip(tp,ec,tc) then aux.SetUnionState(ec) end
	end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c)return c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER and c:IsSetCard(0xc532)end,1,nil)
end
function cm.tgfilter(c,att)
	return c:GetAttribute()&att==0 and c:IsLevel(4) and c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local att=0
	local g=eg:Filter(function(c)return c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER and c:IsSetCard(0xc532)end,nil)
	for tc in aux.Next(g) do att=att+tc:GetOriginalAttribute() end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil,att) end
	e:SetLabel(att)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
