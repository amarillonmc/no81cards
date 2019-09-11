--末氏空骨 骸使
local m=33330508
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLevel,1),4)
	c:EnableReviveLimit()
 --atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
--removed
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,33330511)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.extg)
	e2:SetOperation(cm.exop)
	c:RegisterEffect(e2)
end
--特 招 衍 生 物 
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33330500,0,0x4011,-2,0,1,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,33330500,0,0x4011,-2,0,1,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then
		local atk=Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_REMOVED,0)*500
		local b=(Duel.GetLocationCount(tp,LOCATION_MZONE)==1 or Duel.IsPlayerAffectedByEffect(tp,59822133))
		local token=Duel.CreateToken(tp,33330500)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atk)
		token:RegisterEffect(e1,true)
		if (not b1) and Duel.SelectYesNo(tp,aux.Stringid(33330508,3)) then
			local token=Duel.CreateToken(tp,33330500)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(atk)
			token:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
	
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
--除 外
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.exofil(c)
	return c:IsAbleToRemove() and not c:IsType(TYPE_TOKEN)
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN)
	if g:GetCount()>0 then
		local num=Duel.Destroy(g,REASON_EFFECT)
		local op=2
		if Duel.IsExistingMatchingCard(cm.exofil,tp,0,LOCATION_ONFIELD,1,nil) or (num>=3 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)) then
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		else
			op=0
		end
		if op==0 then
			Duel.Damage(1-tp,num*300,REASON_EFFECT)
		elseif op==1 then
			if num>=3 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				local nn=Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
				if num>nn then num=nn end
				local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,num,nil)
				Duel.HintSelection(g1)
				Duel.SendtoHand(g1,nil,REASON_EFFECT)
			else
				local g2=Duel.SelectMatchingCard(tp,cm.exofil,tp,0,LOCATION_ONFIELD,1,1,nil)
				Duel.HintSelection(g2)
				Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end
