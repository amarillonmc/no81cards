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
	e0:SetCondition(Auxiliary.XyzLevelFreeCondition(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28318027.xyzcheck,2,99))
	e0:SetTarget(Auxiliary.XyzLevelFreeTarget(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28318027.xyzcheck,2,99))
	e0:SetOperation(c28318027.Operation(aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),c28318027.xyzcheck,2,99))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28318027,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c28318027.thcost)
	e1:SetTarget(c28318027.thtg)
	e1:SetOperation(c28318027.thop)
	c:RegisterEffect(e1)
	--rank change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28318027,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c28318027.rctg)
	e2:SetOperation(c28318027.rcop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c28318027.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
--xyz↓
function Auxiliary.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g,xyzc)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function c28318027.xyzcheck(g,xyzc)
	for lv=1,100 do
		if not g:IsExists(function(c) return not c:IsXyzLevel(xyzc,lv) end,1,nil) then return true end
	end
	return false
end
function c28318027.Operation(f,gf,minct,maxct)
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
					c:RegisterFlagEffect(28318027,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,og:GetFirst():GetLevel())
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
					c:RegisterFlagEffect(28318027,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,mg:GetFirst():GetLevel())
					Duel.Overlay(c,mg)
					if mg:GetClassCount(Card.GetLevel)==1 then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetCode(EVENT_SPSUMMON_SUCCESS)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
						e1:SetCondition(c28318027.rscon)
						e1:SetOperation(c28318027.rsop)
						Duel.RegisterEffect(e1,tp)
						c28318027.tab = {}
						table.insert(c28318027.tab,c)
					end
					mg:DeleteGroup()
				end
			end
end
function c28318027.rscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(c28318027.tab[1])
end
function c28318027.rsop(e,tp,eg,ep,ev,re,r,rp)
	for c in aux.Next(eg) do
		if c==c28318027.tab[1] then
			local xlv=c:GetFlagEffectLabel(28318027)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RANK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(xlv)
			c:RegisterEffect(e1)
			c28318027.tab = nil
			e:Reset()
		end
	end
end
--xyz↑
function c28318027.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c28318027.thfilter(c,e,tp)
	return c:IsSetCard(0x284)and (c:IsSSetable() or c:IsAbleToHand() or (Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)))
end
function c28318027.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c28318027.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	--Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28318027.tgfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToGrave()
end
function c28318027.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c28318027.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	else
		if tc:IsAbleToHand() and (not (tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetMZoneCount(tp)>0) or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	if e:GetHandler():IsRankAbove(8) and Duel.IsExistingMatchingCard(c28318027.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28318027,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local gg=Duel.SelectMatchingCard(tp,c28318027.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(gg,REASON_EFFECT)
	end
end
function c28318027.rcfilter(c,rk)
	return c:IsRankAbove(1) and not c:IsRank(rk) and c:IsFaceup()
end
function c28318027.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c28318027.rcfilter(chkc,e:GetHandler():GetRank()) end
	if chk==0 then return Duel.IsExistingTarget(c28318027.rcfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetRank()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c28318027.rcfilter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler():GetRank())
end
function c28318027.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	if c:GetRank()==tc:GetRank() then return end
	if Duel.SelectOption(tp,aux.Stringid(28318027,3),aux.Stringid(28318027,4))==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RANK)
		e1:SetValue(tc:GetRank())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	else
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RANK)
		e2:SetValue(c:GetRank())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		tc:RegisterEffect(e2)
	end
end
function c28318027.atkval(e,c)
	return c:GetRank()*100
end
