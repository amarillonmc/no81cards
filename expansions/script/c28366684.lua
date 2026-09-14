--闪耀的一等星 星星的相会
function c28366684.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(Auxiliary.XyzLevelFreeCondition(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28366684.xyzcheck,2,99))
	e0:SetTarget(Auxiliary.XyzLevelFreeTarget(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28366684.xyzcheck,2,99))
	e0:SetOperation(c28366684.Operation(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28366684.xyzcheck,2,99))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28366684,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SSET+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c28366684.tgcost)
	e1:SetTarget(c28366684.tgtg)
	e1:SetOperation(c28366684.tgop)
	c:RegisterEffect(e1)
end
function c28366684.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c28366684.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=math.floor(e:GetHandler():GetRank()/3)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c28366684.sfilter(c,e,tp)
	return c:IsSetCard(0x283) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetMZoneCount(tp)>0 or c:IsSSetable())
end
function c28366684.tgop(e,tp,eg,ep,ev,re,r,rp)
	--to grave
	local c=e:GetHandler()
	local ct=math.floor(e:GetHandler():GetRank()/3)
	if not c:IsRelateToChain() or ct<1 or Duel.DiscardDeck(tp,ct,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and Duel.IsExistingMatchingCard(c28366684.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(28366684,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,c28366684.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and (not tc:IsSSetable() or Duel.SelectOption(tp,1152,1153)==0) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if #g==0 then return end
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--xyz↓
function c28366684.xyzcheck(g,xyzc)
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
function c28366684.Operation(f,gf,minct,maxct)
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
						e1:SetCondition(c28366684.rscon)
						e1:SetOperation(c28366684.rsop)
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
						e1:SetCondition(c28366684.rscon)
						e1:SetOperation(c28366684.rsop)
						e1:SetLabelObject(c)
						e1:SetLabel(ct)
						Duel.RegisterEffect(e1,tp)
					end
					mg:DeleteGroup()
				end
			end
end
function c28366684.rscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetLabelObject())
end
function c28366684.rsop(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetValue(c28366684.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
	e:Reset()
end
function c28366684.atkval(e,c)
	return c:GetRank()*100
end
--xyz↑
