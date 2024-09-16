--全抗捕食者
function c21185833.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21185833)
	e1:SetCondition(c21185833.con)
	e1:SetTarget(c21185833.tg)
	e1:SetOperation(c21185833.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21185834)
	e2:SetTarget(c21185833.tg2)
	e2:SetOperation(c21185833.op2)
	c:RegisterEffect(e2)
	if not c21185833_immcheck then
		c21185833_immcheck=true
		c21185833_imm_table = {}
		local cg=Duel.GetFieldGroup(0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
		if #cg<=0 then return end
		Immcheck_RegisterEffect = Card["RegisterEffect"]
		Card["RegisterEffect"] = 
		function(card,effect,player,...)
			if effect:GetCode()~=nil and effect:GetCode()==EFFECT_IMMUNE_EFFECT then
			c21185833_imm_table[#c21185833_imm_table+1] = card:GetOriginalCode()
				return true
			end
		end
		for tc in aux.Next(cg) do
			local card_code = _G["c"..tc:GetOriginalCode()]
			do card_code.initial_effect(tc) end
		end
	Card["RegisterEffect"] = Immcheck_RegisterEffect	
	end
end
function c21185833.q(card)
	local x=false
	for i=1,#c21185833_imm_table do
		if card:GetOriginalCode()==c21185833_imm_table[i] then x=true break end
	end
	return x
end
function c21185833.w(c)
	return c21185833.q(c) and c:IsFaceup()
end
function c21185833.con(e,tp,eg,ep,ev,re,r,rp)
	return c21185833_imm_table and #c21185833_imm_table>0 and Duel.IsExistingMatchingCard(c21185833.w,tp,0,12,1,nil)
end
function c21185833.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c21185833.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c21185833.e(c)
	return c21185833.q(c) and c:IsAbleToGrave() and c:IsFaceup()
end
function c21185833.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c21185833.e,tp,0,12,1,nil)
	if #g>0 then
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,#g*1500)
	end
end
function c21185833.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21185833.e,tp,0,12,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_RULE)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and c:IsRelateToEffect(e) then
	local cg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(#cg*1500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	end
end