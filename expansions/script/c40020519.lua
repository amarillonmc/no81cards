--空创手镯兔

local s,id=GetID()
s.named_with_HighEvo=1

function s.HighEvo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_HighEvo
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=e1:Clone()
	e2:SetCode(EFFECT_BATTLE_DAMAGE)
	c:RegisterEffect(e2)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>0
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_NORMAL,1200,1500,3,RACE_BEAST,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.uranus_filter(c)
	return c:IsCode(40020509) and c:IsFaceup()
end

function s.search_filter(c)
	return s.HighEvo(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_NORMAL,1200,1500,3,RACE_BEAST,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		local b_uranus = Duel.IsExistingMatchingCard(s.uranus_filter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,nil)
		local b_draw = Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		local b_search = Duel.IsExistingMatchingCard(s.search_filter,tp,LOCATION_DECK,0,1,nil)
		

		local can_apply = false
		if b_uranus then
			can_apply = b_draw or b_search
		else
			can_apply = b_draw
		end
		
		if can_apply and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			local op=0
			
			if b_uranus and b_search then
				if b_draw then
					op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
				else
					op=1
				end
			else
				op=0
			end
			if op==0 then
				if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
				Duel.Draw(tp,1,REASON_EFFECT)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,s.search_filter,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end