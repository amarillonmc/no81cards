--坎特伯雷 未来骑士
function c65111017.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c65111017.lcheck)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c65111017.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65111017)
	e2:SetCondition(c65111017.atkcon)
	e2:SetTarget(c65111017.atktg)
	e2:SetOperation(c65111017.atkop)
	c:RegisterEffect(e2)
end
function c65111017.lcheck(g)
	return g:IsExists(c65111017.lcfilter,1,nil) 
end
function c65111017.lcfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:IsLinkSetCard(0x831)
end
function c65111017.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c65111017.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c65111017.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
	return g:GetSum(Card.GetBaseAttack)
end
function c65111017.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c65111017.atkval(e,e:GetHandler())>0 end
end
function c65111017.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atkval=c65111017.atkval(e,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atkval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		if c:RegisterEffect(e1) then 
			local dg=Duel.GetMatchingGroup(Card.IsAttackBelow,tp,0,LOCATION_MZONE,nil,c:GetAttack())
			if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65111017,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local des=dg:Select(tp,1,1,nil)
				Duel.HintSelection(des)
				Duel.BreakEffect()
				Duel.Destroy(des,REASON_EFFECT)
			end
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c65111017.ftarget)
		e2:SetLabel(e:GetHandler():GetFieldID())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c65111017.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end