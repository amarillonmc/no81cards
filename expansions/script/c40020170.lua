--假面骑士 空我/究极形态
local s,id=GetID()


s.named_with_Kuuga=1
function s.Kuuga(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kuuga
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(s.attg)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end

function s.hand_kuuga_filter(c)
	return s.Kuuga(c) and c:IsDiscardable(REASON_EFFECT)
end

function s.field_kuuga_lv7_filter(c,tp)
	return s.Kuuga(c) and c:IsFaceup() and c:IsLevelAbove(7) and c:IsAbleToHand() 
		and Duel.GetMZoneCount(tp,c)>0 
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	local b1=c:IsDiscardable(REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,c)
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(s.field_kuuga_lv7_filter,tp,LOCATION_MZONE,0,1,nil,tp)
		
	if chk==0 then return b1 or b2 end
	
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,2,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)

end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)>0 then

		if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_HAND) then return end
		
		local b1=c:IsDiscardable(REASON_EFFECT) 
			and Duel.IsExistingMatchingCard(s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,c)
		local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
			and Duel.IsExistingMatchingCard(s.field_kuuga_lv7_filter,tp,LOCATION_MZONE,0,1,nil,tp)
		
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
		elseif b1 then op=0
		elseif b2 then op=1
		else return end
		
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local dg=Duel.SelectMatchingCard(tp,s.hand_kuuga_filter,tp,LOCATION_HAND,0,1,1,c)
			if #dg>0 then
				dg:AddCard(c)
				Duel.BreakEffect()
				Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local bg=Duel.SelectMatchingCard(tp,s.field_kuuga_lv7_filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
			if #bg>0 then
				Duel.BreakEffect()
				if Duel.SendtoHand(bg,nil,REASON_EFFECT)>0 then
					Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end

function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local re_summon=c:GetReasonEffect()
		local is_kuuga=re_summon and s.Kuuga(re_summon:GetHandler())
		
		if is_kuuga then
			Duel.BreakEffect()
			local lp=Duel.GetLP(1-tp)
			Duel.SetLP(1-tp,math.ceil(lp/2))
		end
	end
end