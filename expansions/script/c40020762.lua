--轰铁之霸皇 西乡魔像
local s,id=GetID()

function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(s.remtg)
	e2:SetOperation(s.remop)
	c:RegisterEffect(e2)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetDecktopGroup(tp,1)
	local g2=Duel.GetDecktopGroup(1-tp,1)
	local b1=#g1>0 and g1:GetFirst():IsAbleToRemoveAsCost(POS_FACEDOWN)
	local b2=#g2>0 and g2:GetFirst():IsAbleToRemove(tp,POS_FACEDOWN,REASON_COST)
	
	if chk==0 then return (b1 or b2) end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=0
	else
		op=1
	end
	
	local target_p = (op==0) and tp or 1-tp
	local ct=Duel.GetFieldGroupCount(target_p,LOCATION_DECK,0)
	if ct>5 then ct=5 end
	local g=Duel.GetDecktopGroup(target_p,ct)
	Duel.DisableShuffleCheck() 
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.place_filter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsForbidden()
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local rel_g=Duel.GetMatchingGroup(function(card) return s.Grandwalker(card) and card:IsReleasableByEffect() end,tp,LOCATION_PZONE,0,nil)
			local hand_g=Duel.GetMatchingGroup(s.place_filter,tp,LOCATION_HAND,0,nil)
			local has_space = Duel.GetLocationCount(tp,LOCATION_SZONE) > 0
			if #rel_g>0 and #hand_g>0 and has_space then
				if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
					local rg=rel_g:Select(tp,1,1,nil)
					
					if Duel.Release(rg,REASON_EFFECT)>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
						local sg1=hand_g:Select(tp,1,1,nil)
						local code1=sg1:GetFirst():GetCode()
						local final_sg=sg1:Clone()
						local remain_space=Duel.GetLocationCount(tp,LOCATION_SZONE)
						local max_select=math.min(2,remain_space)
						if max_select>0 then
							local deck_hand_g=Duel.GetMatchingGroup(function(card)
								return s.place_filter(card) and card:GetCode()~=code1
							end,tp,LOCATION_HAND+LOCATION_DECK,0,sg1:GetFirst())
							
							if #deck_hand_g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
								local sg2=deck_hand_g:SelectSubGroup(tp,aux.dncheck,false,1,max_select)
								if sg2 then final_sg:Merge(sg2) end
							end
						end
						for tc in aux.Next(final_sg) do
							Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
						end
					end
				end
			end
		end
	end
end

function s.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_SZONE,0,nil)*5
	if chk==0 then 
		return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil,tp,POS_FACEDOWN) 
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,1-tp,LOCATION_DECK)
end

function s.remop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_SZONE,0,nil)*5
	if ct<=0 then return end
	
	local d_ct=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	if d_ct==0 then return end
	if d_ct>ct then d_ct=ct end
	
	local g=Duel.GetDecktopGroup(1-tp,d_ct)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end