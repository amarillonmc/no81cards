--模块复制
local m=20000313
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(function(c)return c:IsSetCard(0xfd3)and c:IsFaceup()end,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xfd3,0x21,1500,1500,4,RACE_MACHINE,ATTRIBUTE_EARTH) end
		local g=Duel.GetMatchingGroup(function(c)return c:IsSetCard(0xfd3)and c:IsFaceup()end,tp,LOCATION_MZONE,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Duel.SelectMatchingCard(tp,function(c)return c:IsSetCard(0xfd3)and c:IsFaceup()end,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			local hc=Duel.SendtoHand(g,nil,REASON_EFFECT)
			if hc==1 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
				and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xfd3,0x21,1500,1500,4,RACE_MACHINE,ATTRIBUTE_EARTH) then
				c:AddMonsterAttribute(TYPE_EFFECT)
				Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
				local tc=g:GetFirst()
				local code=tc:GetOriginalCodeRule()
				local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_ADD_CODE)
				e1:SetValue(code)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
			end
		end
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
			and Duel.IsExistingMatchingCard(function(c)return c:IsSetCard(0xfd3)and c:IsFaceup()and c:IsAbleToHandAsCost()end,tp,LOCATION_MZONE,0,1,nil) end
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,function(c)return c:IsSetCard(0xfd3)and c:IsFaceup()and c:IsAbleToHandAsCost()end,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(function(c,e,tp)
			return c:IsSetCard(0xfd3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)end,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,function(c,e,tp)
				return c:IsSetCard(0xfd3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)end,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end)
	c:RegisterEffect(e2)
end
