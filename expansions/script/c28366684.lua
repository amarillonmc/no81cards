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
	--select
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28366684,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,28366684)
	e1:SetCost(c28366684.slcost)
	e1:SetTarget(c28366684.sltg)
	e1:SetOperation(c28366684.slop)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c28366684.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
--xyz↓
function Auxiliary.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g,xyzc)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function c28366684.xyzcheck(g,xyzc)
	for lv=1,100 do
		if not g:IsExists(function(c) return not c:IsXyzLevel(xyzc,lv) end,1,nil) then return true end
	end
	return false
end
function c28366684.Operation(f,gf,minct,maxct)
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
					c:RegisterFlagEffect(28366684,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,og:GetFirst():GetLevel())
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
					c:RegisterFlagEffect(28366684,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,mg:GetFirst():GetLevel())
					local check=mg:GetClassCount(Card.GetLevel)==1
					Duel.Overlay(c,mg)
					if check then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetCode(EVENT_SPSUMMON_SUCCESS)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
						e1:SetCondition(c28366684.rscon)
						e1:SetOperation(c28366684.rsop)
						Duel.RegisterEffect(e1,tp)
						c28366684.tab = {}
						table.insert(c28366684.tab,c)
					end
					mg:DeleteGroup()
				end
			end
end
function c28366684.rscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(c28366684.tab[1])
end
function c28366684.rsop(e,tp,eg,ep,ev,re,r,rp)
	for c in aux.Next(eg) do
		if c==c28366684.tab[1] then
			local xlv=c:GetFlagEffectLabel(28366684)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RANK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(xlv)
			c:RegisterEffect(e1)
			c28366684.tab = nil
			e:Reset()
		end
	end
end
--xyz↑
function c28366684.slcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c28366684.anfilter(c)
	return c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28366684.alfilter(c)
	return c:IsSetCard(0x287) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c28366684.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c28366684.anfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c28366684.alfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
end
function c28366684.setfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c28366684.slop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c28366684.anfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c28366684.alfilter,tp,LOCATION_DECK,0,1,nil)
	if b1 or b2 then
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(28366684,2)},
			{b2,aux.Stringid(28366684,3)})
		if op==1 then
			local lp=Duel.GetLP(tp)
			Duel.SetLP(tp,lp-1000)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c28366684.anfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		elseif op==2 then
			if Duel.Recover(tp,1000,REASON_EFFECT)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,c28366684.alfilter,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoGrave(g,REASON_EFFECT)
				end 
			end
		end
	end
	if e:GetHandler():IsRankAbove(8) and Duel.IsExistingMatchingCard(c28366684.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28366684,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tg=Duel.SelectMatchingCard(tp,c28366684.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SSet(tp,tg)
	end
end
function c28366684.atkval(e,c)
	return c:GetRank()*100
end
