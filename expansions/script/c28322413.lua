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
	e0:SetCondition(Auxiliary.XyzLevelFreeCondition(aux.FilterBoolFunction(Card.IsSetCard,0x284),c28322413.xyzcheck,2,99))
	e0:SetTarget(Auxiliary.XyzLevelFreeTarget(aux.FilterBoolFunction(Card.IsSetCard,0x284),c28322413.xyzcheck,2,99))
	e0:SetOperation(c28322413.Operation(aux.FilterBoolFunction(Card.IsSetCard,0x284),c28322413.xyzcheck,2,99))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
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
	e2:SetCondition(c28322413.rankcon)
	e2:SetLabel(4)
	e2:SetTarget(c28322413.rutg)
	e2:SetOperation(c28322413.ruop)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c28322413.rankcon)
	e3:SetLabel(8)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--immune effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c28322413.rankcon)
	e4:SetLabel(12)
	e4:SetValue(c28322413.immunefilter)
	c:RegisterEffect(e4)
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
function c28322413.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1 and not g:IsExists(Card.IsType,1,nil,TYPE_LINK+TYPE_XYZ)
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
					mg:DeleteGroup()
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
function c28322413.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayGroup():GetCount()>1 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c28322413.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetOverlayGroup():GetCount()
	if ct==0 or not Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c28322413.rankcon(e)
	return e:GetHandler():GetRank()>=e:GetLabel()
end
function c28322413.tdfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c28322413.rutg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28322413.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c28322413.ruop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28322413.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(ct)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x284))
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RANK)
		Duel.RegisterEffect(e2,tp)
	end
end
function c28322413.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and not te:GetHandler():IsType(TYPE_XYZ)
end
function c28322413.atkval(e,c)
	return c:GetRank()*100
end
