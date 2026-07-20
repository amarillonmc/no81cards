--幽魔脚 疯足
local s,id=GetID()
s.named_with_Darkling=1

s.NYX_CODE=40021115
s.COUNTER_DARKLING=0x2f1e

function s.Darkling(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkling
end

function s.initial_effect(c)
	aux.AddCodeList(c,40021115)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.cttg2)
	e2:SetOperation(s.ctop2)
	c:RegisterEffect(e2)
end

function s.nyx_filter(c)
	return c:IsFaceup() and c:IsCode(s.NYX_CODE) and c:IsCanAddCounter(s.COUNTER_DARKLING,1)
end

function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingMatchingCard(s.nyx_filter,tp,LOCATION_PZONE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.nyx_filter,tp,LOCATION_PZONE,0,nil)
	if #g==0 then return end

	local tc=nil
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:GetFirst()
	end
	
	if tc then
		tc:AddCounter(s.COUNTER_DARKLING,1)
		if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
				if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
					Duel.BreakEffect()
					if Duel.Draw(tp,1,REASON_EFFECT)>0 then
						local dc=Duel.GetOperatedGroup():GetFirst()
						if dc and s.Darkling(dc) and dc:IsType(TYPE_MONSTER) 
							and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
							and dc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
							if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
								Duel.ConfirmCards(1-tp,dc)
								Duel.SpecialSummon(dc,0,tp,tp,false,false,POS_FACEUP)
							end
						end
					end
				end
			end
		end
	end
end

function s.nyx_filter2(c)
	return c:IsFaceup() and c:IsCode(s.NYX_CODE) and c:IsCanAddCounter(s.COUNTER_DARKLING,2)
end

function s.cttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.nyx_filter2,tp,LOCATION_PZONE,0,1,nil) end
end

function s.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.nyx_filter2,tp,LOCATION_PZONE,0,nil)
	if #g==0 then return end
	
	local tc=nil
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:GetFirst()
	end
	
	if tc then
		tc:AddCounter(s.COUNTER_DARKLING,2)
	end
end
