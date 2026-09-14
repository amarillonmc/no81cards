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
end
function c28322413.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c28322413.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mt,rt=c:GetOverlayCount(),math.floor(c:GetRank()/3)
	local g=Duel.GetMatchingGroup(c28322413.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,e)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) and (g:IsExists(Card.IsOnField,1,nil) and mt>1 or g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and rt>0 or g:IsExists(Card.IsOnField,1,nil) and mt>0 and Duel.IsExistingMatchingCard(Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,1,c,tp,1,REASON_COST)) end
	if g:IsExists(Card.IsOnField,1,nil) and mt>1 or g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and rt>0 then
		Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
		local tc=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,1,1,c,tp,1,REASON_COST):GetFirst()
		tc:RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function c28322413.tdfilter(c,e)
	return c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c28322413.gcheck(g,mt,rt)
	return g:FilterCount(Card.IsOnField,nil)<=mt and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=rt
end
function c28322413.xfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c28322413.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	local c=e:GetHandler()
	local mt,rt=c:GetOverlayCount(),math.floor(c:GetRank()/3)
	local g=Duel.GetMatchingGroup(c28322413.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,e)
	if chk==0 then return Duel.IsExistingMatchingCard(c28322413.xfilter,tp,LOCATION_MZONE,0,1,nil) and (e:IsCostChecked() or g:IsExists(Card.IsOnField,1,nil) and mt>0 or g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and rt>0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c28322413.gcheck,false,1,mt+rt,mt,rt)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,#sg,0,0)
end
function c28322413.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(c28322413.xfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if #g==0 or ct==0 then return end
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	Duel.HintSelection(Group.FromCards(tc))
	local t={}
	for i=1,ct do table.insert(t,i) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(28322413,0))
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_RANK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(ac)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
--xyz↓
function c28322413.xyzcheck(g,xyzc)
	--GetXyzLevel is not allowed
	local t={}
	for tc in aux.Next(g) do
		if not tc:IsHasEffect(EFFECT_XYZ_LEVEL) then
			table.insert(t,tc:GetLevel())
		else
			for _,te in pairs({tc:IsHasEffect(EFFECT_XYZ_LEVEL)}) do
				local val=te:GetValue()
				local xlv=aux.GetValueType(val)=="Function" and val(te,tc,xyzc) or val
				table.insert(t,xlv&0xffff)
				if xlv>0xffff then table.insert(t,(xlv>>16)&0xffff) end
			end
		end
	end
	for _,lv in pairs(t) do--for lv=1,100 do
		if not g:IsExists(function(c) return not c:IsXyzLevel(xyzc,lv) end,1,nil) then return true end
	end
	return false
end
function c28322413.Operation(f,gf,minct,maxct)
	return function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				local ct=0
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
					if og:GetClassCount(Card.GetLevel)==1 then ct=og:GetFirst():GetLevel() end
					Duel.Overlay(c,og)
					if ct~=0 then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetCode(EVENT_SPSUMMON_SUCCESS)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
						e1:SetCondition(c28322413.rscon)
						e1:SetOperation(c28322413.rsop)
						e1:SetLabelObject(c)
						e1:SetLabel(ct)
						Duel.RegisterEffect(e1,tp)
					end
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
					if mg:GetClassCount(Card.GetLevel)==1 then ct=mg:GetFirst():GetLevel() end
					Duel.Overlay(c,mg)
					if ct~=0 then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetCode(EVENT_SPSUMMON_SUCCESS)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
						e1:SetCondition(c28322413.rscon)
						e1:SetOperation(c28322413.rsop)
						e1:SetLabelObject(c)
						e1:SetLabel(ct)
						Duel.RegisterEffect(e1,tp)
					end
					mg:DeleteGroup()
				end
			end
end
function c28322413.rscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetLabelObject())
end
function c28322413.rsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_RANK)
	--e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(e:GetLabel())
	e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	tc:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c28322413.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
	e:Reset()
end
function c28322413.atkval(e,c)
	return c:GetRank()*100
end
--xyz↑
