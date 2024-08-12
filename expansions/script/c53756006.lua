if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53756006
local cm=_G["c"..m]
cm.name="指导教师 濑美奈"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_SPSUMMON+TIMING_CHAIN_END,TIMING_SPSUMMON+TIMING_CHAIN_END+TIMING_END_PHASE)
	e1:SetCost(cm.damcost)
	e1:SetTarget(cm.damtg)
	e1:SetOperation(cm.damop)
	c:RegisterEffect(e1)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e1:SetLabelObject(sg)
	aux.RegisterMergedDelayedEvent(c,m,EVENT_SPSUMMON_SUCCESS)
	aux.RegisterMergedDelayedEvent(c,m+50,EVENT_MOVE)
end
function cm.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST)~=0 then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		e1:SetLabel(Duel.GetTurnCount())
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(m)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)
end
function cm.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xa530)
end
function cm.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xa530) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetCategory(CATEGORY_DAMAGE)
	local sg=e:GetLabelObject()
	sg:Clear()
	local op=0
	local res1,teg1,tep1,tev1,tre1,tr1,trp1=Duel.CheckEvent(EVENT_CUSTOM+m,true)
	if res1 and teg1:IsExists(cm.cfilter1,1,nil) then
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_SEARCH+CATEGORY_TOHAND)
		op=op+1
	end
	local res2,teg2,tep2,tev2,tre2,tr2,trp2=Duel.CheckEvent(EVENT_CUSTOM+(m+50),true)
	if res2 and teg2:IsExists(cm.cfilter2,1,nil) then
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
		teg2:ForEach(Card.CreateEffectRelation,e)
		sg:Merge(teg2)
		op=op+2
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000)
end
function cm.thfilter(c)
	return c:IsCode(m+1) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return c:IsRelateToEffect(e) and cm.cfilter2(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam1=Duel.Damage(tp,1000,REASON_EFFECT,true)
	local dam2=Duel.Damage(1-tp,1000,REASON_EFFECT,true)
	Duel.RDComplete()
	if dam1+dam2<=0 then return end
	local op=e:GetLabel()
	if op==0 then return end
	if op~=2 then
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
		if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.SendtoHand(sg1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg1)
		end
	end
	if op~=1 then
		local g2=e:GetLabelObject():Filter(cm.spfilter,nil,e,tp)
		if #g2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			local tc=g2:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			if #g2>1 then tc=g2:Select(tp,1,1,nil):GetFirst() end
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
