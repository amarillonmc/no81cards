--虹光的一等星 无限的可能
function c28322413.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(Auxiliary.XyzLevelFreeCondition(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28322413.xyzcheck,2,99))
	e0:SetTarget(Auxiliary.XyzLevelFreeTarget(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28322413.xyzcheck,2,99))
	e0:SetOperation(c28322413.Operation(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28322413.xyzcheck,2,99))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c28322413.tdcon)
	e1:SetCost(c28322413.tdcost)
	e1:SetTarget(c28322413.tdtg)
	e1:SetOperation(c28322413.tdop)
	c:RegisterEffect(e1)
	--rank up
	local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c28322413.rucost)
	--e2:SetTarget(c28322413.rutg)
	e2:SetOperation(c28322413.ruop)
	c:RegisterEffect(e2)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c28322413.atkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
end
--xyz↓
function Auxiliary.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g,xyzc)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function c28322413.xyzcheck(g,xyzc)
	for lv=1,100 do
		if not g:IsExists(function(c) return not c:IsXyzLevel(xyzc,lv) end,1,nil) then return true end
	end
	return false
end
function c28322413.Operation(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					c:RegisterFlagEffect(28322413,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,og:GetFirst():GetLevel())
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					c:RegisterFlagEffect(28322413,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,mg:GetFirst():GetLevel())
					local check=mg:GetClassCount(Card.GetLevel)==1
					Duel.Overlay(c,mg)
					if check then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetCode(EVENT_SPSUMMON_SUCCESS)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
						e1:SetCondition(c28322413.rscon)
						e1:SetOperation(c28322413.rsop)
						Duel.RegisterEffect(e1,tp)
						c28322413.tab = {}
						table.insert(c28322413.tab,c)
					end
					mg:DeleteGroup()
				end
			end
end
function c28322413.rscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(c28322413.tab[1])
end
function c28322413.rsop(e,tp,eg,ep,ev,re,r,rp)
	for c in aux.Next(eg) do
		if c==c28322413.tab[1] then
			local xlv=c:GetFlagEffectLabel(28322413)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RANK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(xlv)
			c:RegisterEffect(e1)
			c28322413.tab = nil
			e:Reset()
		end
	end
end
--xyz↑
function c28322413.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c28322413.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c28322413.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	local ct=e:GetHandler():GetOverlayGroup():GetCount()
	if chk==0 then return ct>1 and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function c28322413.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c28322413.tdfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceupEx()-- and aux.NecroValleyFilter()(c)
end
function c28322413.rucost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28322413.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c28322413.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	e:SetLabel(#g)
end
function c28322413.ruop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_RANK)
		e0:SetValue(ct)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e0)
	end
end
function c28322413.atkval(e,c)
	return c:GetRank()*100
end
