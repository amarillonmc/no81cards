--深夜急行少女
local m=64800083
local cm=_G["c"..m]
function cm.initial_effect(c)
	  --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsFacedown()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1))then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
		local tg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		local tc=tg:GetFirst()
		Duel.ConfirmCards(tp,tc)
		if tc:IsType(TYPE_MONSTER) then 
		Duel.ChangePosition(tc,POS_FACEUP) 
		end
		if tc:IsType(TYPE_TRAP+TYPE_SPELL)  then
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			if  te then   
				local condition=te:GetCondition()
				local cost=te:GetCost()
				local target=te:GetTarget()
				local operation=te:GetOperation()
				if te:GetCode()==EVENT_FREE_CHAIN and te:IsActivatable(tep)
					and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
					and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
					and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
					e:SetProperty(te:GetProperty())
					Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
					Duel.ChangePosition(tc,POS_FACEUP)
					if not (tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD))  then
						tc:CancelToGrave(false)
					end
					tc:CreateEffectRelation(te)
					if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
					if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
					if Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) then 
					local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)			   
					local tg=g:GetFirst()
					while tg do
						tg:CreateEffectRelation(te)
						tg=g:GetNext()
					end
					end
					if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
					tc:ReleaseEffectRelation(te)
					if Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) then 
					local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)		  
					tg=g:GetFirst()
					while tg do
						tg:ReleaseEffectRelation(te)
						tg=g:GetNext()
					end
					end
				end
			end
		end
	end
end