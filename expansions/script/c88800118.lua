--深渊的呼唤VII 灾厄之主
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,s.ffilter,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)
	s.to(c)
	s.dis(c)
end
function s.ffilter(c)
	return c:IsFusionSetCard(0x882) and c:IsFusionType(TYPE_FUSION)
end
function s.dis(c)
	--spsummon
	local ge1=Effect.CreateEffect(c)
	ge1:SetDescription(1131)
	ge1:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	ge1:SetType(EFFECT_TYPE_IGNITION)
	ge1:SetCountLimit(1,id)
	ge1:SetRange(LOCATION_MZONE)
	ge1:SetTarget(s.sptg)
	ge1:SetOperation(s.spop)
	c:RegisterEffect(ge1)
	local e1=ge1:Clone()
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local b1=tc:IsType(TYPE_MONSTER) and tc:IsFaceup() and tc:IsCanTurnSet()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsType(TYPE_SPELL+TYPE_TRAP) 
			and not tc:IsType(TYPE_FIELD+TYPE_PENDULUM)
		local b3=tc:IsType(TYPE_FIELD)
	local reset=RESET_EVENT+RESETS_STANDARD
	if b1 or b2 or b3 then reset=RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN end
	local res=0
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(reset)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(reset)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(reset)
			tc:RegisterEffect(e3)
		end
		if tc:IsType(TYPE_MONSTER) and tc:IsFaceup() and tc:IsCanTurnSet() then
			Duel.BreakEffect()
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
		if b2 or b3 then
			Duel.BreakEffect()
			if not tc:IsType(TYPE_CONTINUOUS+TYPE_FIELD) then tc:CancelToGrave() end
			Duel.ChangePosition(tc,POS_FACEDOWN)
			if b3 then
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEDOWN,true)
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			end
			Duel.RaiseEvent(tc,EVENT_SSET,e,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function s.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	e1:Reset()
end
function s.to(c)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(1122)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(s.tgtg)
	e4:SetOperation(s.tgop)
	c:RegisterEffect(e4)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,1000,REASON_EFFECT)~=0 then
		local d=Duel.GetAttackTarget()
		if d:IsRelateToBattle() and d:IsDefensePos() then
			Duel.Overlay(e:GetHandler(),d)
		end
	end
end