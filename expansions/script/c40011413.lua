--强袭飞翔母舰
local m=40011413
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--to hand & spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.check(c,e,tp)
	return c:IsSetCard(0xf11) and c:IsFaceup()
end
function cm.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xf11) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local b1=Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_MZONE,0,1,nil) and #g>0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local b1=Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_MZONE,0,1,nil) and #g>0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #sg>0
	local op=2
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else 
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1 
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		if dg:GetCount()>0 then
			Duel.HintSelection(dg)
			if Duel.Destroy(dg,REASON_EFFECT)==0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
				local ag=Duel.SelectMatchingCard(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,nil)
				if ag:GetCount()>0 then
					local tc=ag:GetFirst()
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_ATTACK_FINAL)
					e1:SetValue(0)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
				end
			end
		end
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local rg=sg:Select(tp,1,1,nil)
		if rg:GetCount()>0 then
			Duel.SpecialSummon(rg,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		return
	end
end
