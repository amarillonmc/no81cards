--加帕里公园 - 神圣之山
function c33700103.initial_effect(c)
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700103,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCost(c33700103.cost)
	e1:SetTarget(c33700103.sptg)
	e1:SetOperation(c33700103.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(33700103,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetTarget(c33700103.sptg2)
	e2:SetOperation(c33700103.spop2)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c33700103.recost)
	e3:SetTarget(c33700103.retg)
	e3:SetOperation(c33700103.reop)
	c:RegisterEffect(e3)
end
function c33700103.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c33700103.filter0(c)
   return  c:IsSetCard(0x442) and c:IsFaceup()
end
function c33700103.filter1(c,e,tp,sg)
   return c:IsAbleToHand() and c:IsSetCard(0x442) and c:IsFaceup()
  and Duel.IsExistingMatchingCard(c33700103.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,sg,nil,e,tp,c:GetCode())
end
function c33700103.filter2(c,e,tp,g)
   return c:GetCode()~=g and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700103.filter3(c,e,tp,pg)
   return not pg:IsExists(c33700103.filter4,1,nil,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700103.filter4(c,g)
   return  c:GetCode()==g:GetCode()
end
function c33700103.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 local sg=Duel.GetMatchingGroup(c33700103.filter0,tp,LOCATION_MZONE,0,nil) 
   if chk==0 then return Duel.IsExistingMatchingCard(c33700103.filter1,tp,LOCATION_MZONE,0,sg:GetCount(),nil,e,tp,sg:GetCount()) and 
   not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,sg:GetCount(),0,0)
end
function c33700103.spop(e,tp,eg,ep,ev,re,r,rp)
   if not e:GetHandler():IsRelateToEffect(e) then return end 
	local sg1=Duel.GetMatchingGroup(c33700103.filter0,tp,LOCATION_MZONE,0,nil)
	local sg2=Duel.GetMatchingGroup(c33700103.filter1,tp,LOCATION_MZONE,0,nil,e,tp,sg1:GetCount())
	if sg1:GetCount()~=sg2:GetCount() then return end
	local tg=Duel.SendtoHand(sg2,nil,REASON_EFFECT)
	local pg=Duel.GetOperatedGroup()
	if tg>0 then
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local cg=Duel.SelectMatchingCard(tp,c33700103.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,tg,tg,nil,e,tp,pg)
	if cg:GetCount()>0 then
	local tc=cg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
			tc=cg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
end
function c33700103.filter5(c,e,tp,sg)
   return c:IsAbleToDeck() and c:IsSetCard(0x442) and c:IsFaceup()
  and Duel.IsExistingMatchingCard(c33700103.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,sg,nil,e,tp,c:GetCode())
end
function c33700103.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	 local sg=Duel.GetMatchingGroup(c33700103.filter0,tp,LOCATION_MZONE,0,nil) 
   if chk==0 then return Duel.IsExistingMatchingCard(c33700103.filter5,tp,LOCATION_MZONE,0,sg:GetCount(),nil,e,tp,sg:GetCount()) and 
   not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,sg:GetCount(),0,0)
end
function c33700103.spop2(e,tp,eg,ep,ev,re,r,rp)
   if not e:GetHandler():IsRelateToEffect(e) then return end 
	local sg1=Duel.GetMatchingGroup(c33700103.filter0,tp,LOCATION_MZONE,0,nil)
	local sg2=Duel.GetMatchingGroup(c33700103.filter5,tp,LOCATION_MZONE,0,nil,e,tp,sg1:GetCount())
	if sg1:GetCount()~=sg2:GetCount() then return end
	local tg=Duel.SendtoDeck(sg2,nil,2,REASON_EFFECT)
	local pg=Duel.GetOperatedGroup()
	if tg>0 then
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local cg=Duel.SelectMatchingCard(tp,c33700103.filter3,tp,LOCATION_DECK,0,tg,tg,nil,e,tp,pg)
	if cg:GetCount()>0 then
	  Duel.SpecialSummon(cg,0,tp,tp,false,false,POS_FACEUP)
	end
end
end
function c33700103.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c33700103.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetChainLimit(aux.FALSE)
end
function c33700103.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end