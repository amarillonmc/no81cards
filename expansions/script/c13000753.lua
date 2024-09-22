--小凤凰
local m=13000753
local cm=_G["c"..m]
function c13000753.initial_effect(c)
	c:EnableReviveLimit()
local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1,m)
	e5:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e5:SetCondition(cm.negcon)
	e5:SetTarget(cm.negtg)
	e5:SetCost(cm.cost)
	e5:SetOperation(cm.negop)
	c:RegisterEffect(e5)
local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(cm.retreg)
	c:RegisterEffect(e3)
end
function cm.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000-RESET_TOGRAVE-RESET_LEAVE+RESET_PHASE+PHASE_END)--减去送墓重置即可
	e1:SetCondition(aux.SpiritReturnConditionForced)
	e1:SetTarget(cm.rettg)
	e1:SetOperation(cm.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(aux.SpiritReturnConditionOptional)
	c:RegisterEffect(e2)
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_GRAVE,0,1,nil)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0
		and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3))
		then
		 ::cancel::
		 local mg=Duel.GetRitualMaterial(tp)
		  if mg:GetCount()>0 then
		local tg=Duel.GetMatchingGroup(cm.filter4,tp,LOCATION_GRAVE,0,nil,e,tp,mg)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			tg=tg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if tc then
				mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
				if tc.mat_filter then
					mg=mg:Filter(tc.mat_filter,tc,tp)
				else
					mg:RemoveCard(tc)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
				local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
				aux.GCheckAdditional=nil
				if not mat then
					aux.RCheckAdditional=nil
					aux.RGCheckAdditional=nil
					goto cancel
				end
				tc:SetMaterial(mat)
				local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
				if dmat:GetCount()>0 then
					mat:Sub(dmat)
					Duel.Remove(dmat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
				end
				Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
	   end
end
end
end
function cm.filter1(c)
	return c:IsType(TYPE_RITUAL)
end
function cm.filter2(c)
	return c:IsPublic() and Card.IsAbleToRemoveAsCost(c,POS_FACEUP)
end
function cm.filter3(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function cm.hspgcheck(td,lv)   
	return td:CheckWithSumGreater(Card.GetLevel,lv)
end
function cm.filter4(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil,tp)
	end
	return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function cm.matfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,0,1,c) end
	
	Duel.DiscardHand(tp,cm.filter1,1,1,REASON_COST+REASON_DISCARD,c)
   
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) 
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) and Duel.IsChainNegatable(ev) then
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local gg=g:Filter(cm.filter1,nil)
	if #gg>0 then
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.Destroy(gg,REASON_EFFECT)
	end
end
end
end

