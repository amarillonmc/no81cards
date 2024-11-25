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
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c28322413.tdcon)
	e1:SetCost(c28322413.tdcost)
	e1:SetTarget(c28322413.tdtg)
	e1:SetOperation(c28322413.tdop)
	c:RegisterEffect(e1)
	--rank up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	--e2:SetCondition(c28322413.rankcon)
	e2:SetTarget(c28322413.rutg)
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
					Duel.Overlay(c,mg)
					if mg:GetClassCount(Card.GetLevel)==1 then
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
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function c28322413.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c28322413.tdfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function c28322413.rutg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28322413.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c28322413.ruop(e,tp,eg,ep,ev,re,r,rp)
	--not target
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRankAbove,8))
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	--to deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28322413.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCondition(c28322413.adcon)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetOperation(c28322413.adop)
		e1:SetLabel(ct)
		e1:SetLabelObject(e:GetHandler())
		Duel.RegisterEffect(e1,tp)
		table.insert(c28322413.et,{e1})
	end
end
function c28322413.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28322413.adf,tp,LOCATION_MZONE,0,1,nil,e)
end
function c28322413.adop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local c,g= e:GetLabelObject(),Duel.GetMatchingGroup(c28322413.adf,tp,LOCATION_MZONE,0,nil,e)
	for xc in aux.Next(g) do
		local x
		if xc:GetLevel()>0 then x=EFFECT_UPDATE_LEVEL
		elseif xc:GetRank()>0 then x=EFFECT_UPDATE_RANK end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(x)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(ct)
		e1:SetCondition(c28322413.efcon)
		e1:SetOwnerPlayer(tp)
		xc:RegisterEffect(e1)
		table.insert(c28322413.get(e),xc)
	end
end
function c28322413.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetControler()==e:GetOwnerPlayer()
end
c28322413.et = { }
function c28322413.get(v)
	for _,i in ipairs(c28322413.et) do
		if i[1]==v then return i end
	end
end
function c28322413.ck(e,c)
	local t = c28322413.get(e)
	for _,v in ipairs(t) do
		if v == c then return false end
	end
	return true
end
function c28322413.adf(c,e)
	return c:IsSetCard(0x284) and (c:GetLevel()>0 or c:GetRank()>0) and c28322413.ck(e,c)
end
function c28322413.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and not te:GetHandler():IsType(TYPE_XYZ)
end
function c28322413.atkval(e,c)
	return c:GetRank()*100
end
