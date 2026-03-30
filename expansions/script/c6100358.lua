--剑装机岚·深黯
local s,id,o=GetID()
function s.initial_effect(c)
	--①：展示手卡 -> 特召卡组 -> 手卡机械族送墓/除外
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	--②：改名
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon1)
	e2:SetTarget(s.sptg1)
	e2:SetOperation(s.spop1)
	c:RegisterEffect(e2)

end

-- === 效果① ===
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x610) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end

function s.handfilter(c)
	return c:IsRace(RACE_MACHINE) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.handfilter,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			-- 手卡1只机械族怪兽送去墓地或除外
			local hg=Duel.GetMatchingGroup(s.handfilter,tp,LOCATION_HAND,0,nil)
			if #hg>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2)) -- "选择怪兽"
				local tc=hg:Select(tp,1,1,nil):GetFirst()
				if tc then
					local b1=tc:IsAbleToGrave()
					local b2=tc:IsAbleToRemove()
					local op=0
					-- 如果既能送墓又能除外，让玩家选择
					if b1 and b2 then
						op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4)) -- "送去墓地", "除外"
					elseif b1 then
						op=0
					else
						op=1
					end
					
					if op==0 then
						Duel.SendtoGrave(tc,REASON_EFFECT)
					else
						Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
					end
				end
			end
		end
	end
end

-- === 效果③ ===
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	-- 墓地的这张卡被除外的场合
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end

function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 从场上离开的场合回到卡组最下面
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3301) -- 系统自带："从场上离开的场合回到卡组最下面"
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(LOCATION_DECKBOT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
	end
end