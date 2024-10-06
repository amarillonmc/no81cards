--灭剑焰龙·双极模式γ
function c60010247.initial_effect(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c60010247.splimit)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c60010247.sptg)
	e1:SetOperation(c60010247.spop)
	c:RegisterEffect(e1)
	--immune & disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c60010247.indcon)
	e2:SetValue(c60010247.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetTargetRange(0,LOCATION_ONFIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60010247.indcon)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetValue(DOUBLE_DAMAGE)
	e4:SetCondition(c60010247.pcon)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCountLimit(1,60010247)
	e5:SetCondition(aux.bdocon)
	e5:SetTarget(c60010247.destg)
	e5:SetOperation(c60010247.desop)
	c:RegisterEffect(e5)
end
function c60010247.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c60010247.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c60010247.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60010247.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLevelAbove(1) then return end
	local g=Duel.GetMatchingGroup(c60010247.spfilter,0,LOCATION_HAND,0,nil,e,tp,e:GetHandler():GetLevel())
	local ct=Duel.GetMZoneCount(tp)
	if #g==0 or ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,ct,nil,e,tp,e:GetHandler():GetLevel())
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(500)
			tc:RegisterEffect(e1)
			Card.RegisterFlagEffect(tc,60002134,RESET_EVENT+RESETS_STANDARD,0,1) --card 
			Duel.RegisterFlagEffect(tp,60002134,RESET_PHASE+PHASE_END,0,1) --ply t turn
			Duel.RegisterFlagEffect(tp,60002135,RESET_PHASE+PHASE_END,0,1000) --ply fore
			if Duel.GetFlagEffect(tp,60002134)>=2 then 
				Duel.Draw(tp,1,REASON_EFFECT)
			end
			if Duel.GetFlagEffect(tp,60002134)>=4 then 
				Duel.Damage(1-tp,500,REASON_EFFECT)
				Duel.Recover(tp,500,REASON_EFFECT)
			end
		end
	end
end
function c60010247.indcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():GetFlagEffect(60002134)~=0 and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c60010247.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c60010247.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(60002134)~=0
end
function c60010247.desfilter(c)
	return c:GetFlagEffect(60002134)==0
end
function c60010247.atkfilter(c)
	return c:GetFlagEffect(60002134)~=0
end
function c60010247.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60010247.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c60010247.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010247.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():GetCount()
	local ag=Duel.GetMatchingGroup(c60010247.atkfilter,tp,LOCATION_MZONE,0,nil)
	if ct>0 and #ag>0 then
		for tc in aux.Next(ag) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1000)
			tc:RegisterEffect(e1)
		end
	end
end
