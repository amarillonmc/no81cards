--微光的一等星 闪耀的准备
function c28318027.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(Auxiliary.XyzLevelFreeCondition(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28318027.xyzcheck,2,283))
	e0:SetTarget(Auxiliary.XyzLevelFreeTarget(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28318027.xyzcheck,2,283))
	e0:SetOperation(c28318027.Operation(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28318027.xyzcheck,2,283))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28318027,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c28318027.tgcost)
	e1:SetTarget(c28318027.tgtg)
	e1:SetOperation(c28318027.tgop)
	c:RegisterEffect(e1)
	--[[--rank change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28318027,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c28318027.rctg)
	e2:SetOperation(c28318027.rcop)
	c:RegisterEffect(e2)]]
end
function c28318027.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c28318027.tgfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToGrave()
end
function c28318027.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c28318027.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsRankAbove(3) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c28318027.tdfilter(c,res)
	return (c:IsAbleToDeck() or res and c:IsAbleToHand()) and aux.NecroValleyFilter()(c)
end
function c28318027.tgop(e,tp,eg,ep,ev,re,r,rp)
	--to grave
	local c=e:GetHandler()
	local ct=math.floor(e:GetHandler():GetRank()/3)
	if not c:IsRelateToChain() or ct<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28318027.tgfilter,tp,LOCATION_DECK,0,1,ct,nil)
	if #g==0 or Duel.SendtoGrave(g,REASON_EFFECT)==0 then return end
	--to deck
	local res=Duel.GetOperatedGroup():IsExists(Card.IsLocation,3,nil,LOCATION_GRAVE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c28318027.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,res):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if tc:IsAbleToDeck() and (not res or not tc:IsAbleToHand() or Duel.SelectOption(tp,1193,1190)==0) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c28318027.rcfilter(c,rk)
	return c:IsRankAbove(1) and not c:IsRank(rk) and c:IsFaceup()
end
function c28318027.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28318027.rcfilter(chkc,e:GetHandler():GetRank()) end
	if chk==0 then return Duel.IsExistingMatchingCard(c28318027.rcfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetRank()) end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	--Duel.SelectTarget(tp,c28318027.rcfilter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler():GetRank())
end
function c28318027.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c28318027.rcfilter,tp,LOCATION_MZONE,0,nil,c:GetRank())
	if #g==0 then return end
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.SelectOption(tp,aux.Stringid(28318027,3),aux.Stringid(28318027,4))==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RANK)
		e1:SetValue(tc:GetRank())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	else
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RANK)
		e2:SetValue(c:GetRank())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
--xyz↓
function c28318027.xyzcheck(g,xyzc)
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
function c28318027.Operation(f,gf,minct,maxct)
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
						e1:SetCondition(c28318027.rscon)
						e1:SetOperation(c28318027.rsop)
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
						e1:SetCondition(c28318027.rscon)
						e1:SetOperation(c28318027.rsop)
						e1:SetLabelObject(c)
						e1:SetLabel(ct)
						Duel.RegisterEffect(e1,tp)
					end
					mg:DeleteGroup()
				end
			end
end
function c28318027.rscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetLabelObject())
end
function c28318027.rsop(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetValue(c28318027.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
	e:Reset()
end
function c28318027.atkval(e,c)
	return c:GetRank()*100
end
--xyz↑
