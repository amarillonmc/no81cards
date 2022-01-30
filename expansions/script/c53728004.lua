local m=53728004
local cm=_G["c"..m]
cm.name="巨征啼鸟 克星"
function cm.initial_effect(c)
	c:EnableReviveLimit()
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
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.xyzfilter(c)
	return c:IsFaceup() and (c:GetOriginalRace()&RACE_MACHINE~=0 or not c:IsLocation(LOCATION_MZONE)) and (c:IsRace(RACE_MACHINE) or not c:IsLocation(LOCATION_SZONE))
end
function cm.thfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_UNION) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetOverlayGroup(tp,1,0):Filter(cm.thfilter,nil)
	g1:Merge(g2)
	if chk==0 then return #g1>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_OVERLAY)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetOverlayGroup(tp,1,0):Filter(cm.thfilter,nil)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		local ug=Duel.GetMatchingGroup(function(c,ec,tp)return c:IsFaceup() and ec:CheckUnionTarget(c) and aux.CheckUnionEquip(ec,c)end,tp,LOCATION_MZONE,0,nil,tc,tp)
		if #ug>0 and tc:CheckUniqueOnField(tp) and not tc:IsForbidden() and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local ec=ug:Select(tp,1,1,nil):GetFirst()
			if ec and Duel.Equip(tp,tc,ec) then aux.SetUnionState(tc) end
		end
	end
end
