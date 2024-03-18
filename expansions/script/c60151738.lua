--*天晶部队 造化神
local m=60151738
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.afffilter,3,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.desop)
	e1:SetCondition(cm.econ)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(cm.econ)
	e3:SetOperation(cm.desop1)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.econ)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4) 
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,60151738)
	e5:SetTarget(cm.target2)
	e5:SetOperation(cm.operation2)
	c:RegisterEffect(e5)
end
function cm.afffilter(c,fc)
	return c:IsSetCard(0x3b26) and c:GetSummonLocation()==LOCATION_GRAVE and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function cm.desfilter(c,fc)
	return c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60151738)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	local tc=g:GetFirst()
	if tc and Duel.Destroy(tc,REASON_EFFECT) then
		local lp=Duel.GetLP(1-tp)
		Duel.SetLP(1-tp,lp-tc:GetBaseAttack())
	end
end
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60151738)
	if bit.band(r,REASON_EFFECT)~=0 then
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	local lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,lp-500)
end
function cm.econ(e,tp)
	local c=e:GetHandler()
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter2(c,ft)
	if ft==0 then
		return c:IsDestructable() and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
	else
		return c:IsDestructable() and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
	end
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,ft)
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,nil,ft)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.Destroy(g,REASON_EFFECT)~=0 then
				if tc:IsRelateToEffect(e) then
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
					if g:GetFirst():IsPreviousLocation(LOCATION_HAND) then
						Duel.Draw(tp,1,REASON_EFFECT)
					end
				end
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,ft)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.Destroy(g,REASON_EFFECT)~=0 then
				if tc:IsRelateToEffect(e) then
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
					if g:GetFirst():IsPreviousLocation(LOCATION_HAND) then
						Duel.Draw(tp,1,REASON_EFFECT)
					end
				end
			end
		end
	end
end